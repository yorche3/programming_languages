package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"strings"
)

type testEvent struct {
	Action  string
	Package string
	Test    string
	Output  string
}

type testKey struct {
	pkg  string
	name string
}

func run() error {
	if len(os.Args) != 1 {
		return errors.New("test: uso inválido / invalid usage: go_test_runner.go")
	}

	cmd := exec.Command("go", "test", "-count=1", "-json", "./...")
	cmd.Stderr = os.Stderr
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return fmt.Errorf("test: no se pudo abrir la salida Go / could not open Go output: %w", err)
	}
	if err := cmd.Start(); err != nil {
		return fmt.Errorf("test: no se pudo iniciar Go / could not start Go: %w", err)
	}

	tests := make(map[testKey]string)
	packages := make(map[string]string)
	buildFailed := false
	var parseErr error
	decoder := json.NewDecoder(stdout)
	for {
		var event testEvent
		err := decoder.Decode(&event)
		if err == io.EOF {
			break
		}
		if err != nil {
			parseErr = fmt.Errorf("test: informe Go JSON inválido / invalid Go JSON report: %w", err)
			break
		}
		if event.Output != "" {
			if _, err := io.WriteString(os.Stdout, event.Output); err != nil {
				parseErr = fmt.Errorf("test: no se pudo imprimir la salida Go / could not print Go output: %w", err)
				break
			}
		}
		switch event.Action {
		case "build-output":
			continue
		case "build-fail":
			buildFailed = true
			continue
		case "start", "run", "pause", "cont", "pass", "fail", "skip", "output":
		default:
			parseErr = fmt.Errorf("test: evento Go desconocido / unknown Go event: %q", event.Action)
		}
		if event.Package == "" {
			parseErr = errors.New("test: evento Go sin paquete / Go event without package")
		}
		if parseErr != nil {
			break
		}
		if event.Test == "" {
			switch event.Action {
			case "start":
				if _, exists := packages[event.Package]; exists {
					parseErr = errors.New("test: inicio Go duplicado / duplicate Go package start")
				} else {
					packages[event.Package] = "start"
				}
			case "pass", "fail", "skip":
				if packages[event.Package] != "start" {
					parseErr = errors.New("test: resultado Go sin inicio / Go package result without start")
				} else {
					packages[event.Package] = event.Action
				}
			}
		} else {
			key := testKey{event.Package, event.Test}
			switch event.Action {
			case "run":
				if _, exists := tests[key]; exists {
					parseErr = errors.New("test: prueba Go duplicada / duplicate Go test")
				} else {
					tests[key] = "run"
				}
			case "pass", "fail", "skip":
				if tests[key] != "run" {
					parseErr = errors.New("test: resultado Go sin inicio / Go test result without start")
				} else {
					tests[key] = event.Action
				}
			}
		}
		if parseErr != nil {
			break
		}
	}
	if parseErr != nil {
		_ = stdout.Close()
	}
	waitErr := cmd.Wait()
	if parseErr != nil {
		return parseErr
	}
	if waitErr != nil {
		return fmt.Errorf("test: Go falló / Go failed: %w", waitErr)
	}
	if buildFailed {
		return errors.New("test: construcción Go fallida / Go build failed")
	}
	for _, status := range packages {
		if status != "pass" && status != "skip" {
			return errors.New("test: ejecución Go incompleta o fallida / incomplete or failed Go package")
		}
	}

	parents := make(map[testKey]bool)
	for key := range tests {
		parent := key.name
		for strings.Contains(parent, "/") {
			parent = parent[:strings.LastIndex(parent, "/")]
			parents[testKey{key.pkg, parent}] = true
		}
	}
	passed, skipped := 0, 0
	for key, status := range tests {
		if status == "run" || status == "fail" {
			return errors.New("test: prueba Go incompleta o fallida / incomplete or failed Go test")
		}
		if packages[key.pkg] != "pass" {
			return errors.New("test: prueba Go sin paquete aprobado / Go test without passed package")
		}
		if parents[key] {
			continue
		}
		if status == "skip" {
			skipped++
			continue
		}
		parent := key.name
		approved := true
		for strings.Contains(parent, "/") {
			parent = parent[:strings.LastIndex(parent, "/")]
			if tests[testKey{key.pkg, parent}] != "pass" {
				approved = false
				break
			}
		}
		if approved {
			passed++
		}
	}
	fmt.Printf("Go tests: %d passed, %d skipped (leaf tests)\n", passed, skipped)
	if passed == 0 {
		return errors.New("test: no se ejecutaron casos Go aprobados / no Go test cases passed")
	}
	return nil
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
