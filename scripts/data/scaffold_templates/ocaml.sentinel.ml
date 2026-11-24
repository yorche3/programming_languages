let () =
  Alcotest.run "Scaffold"
    [
      ( "scaffold",
        [
          Alcotest.test_case "suite missing" `Quick (fun () ->
              Alcotest.fail "No contract tests configured");
        ] );
    ]
