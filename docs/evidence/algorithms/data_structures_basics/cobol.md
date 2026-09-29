# Evidencia — cobol algorithms/data_structures_basics

<!-- glot:evidence
lang=cobol
phase=algorithms
module=data_structures_basics
branch=feat/algorithms/data-structures-basics
commit=602645a
dirty=no
date=2026-09-28T22:24:05-06:00
test_exit=0
test_cmd=make test
verify_exit=-
verdict=green
-->

| Dato | Valor |
|------|-------|
| Lenguaje / Language | `cobol` |
| Fase y módulo / Phase and module | `algorithms/data_structures_basics` |
| Especificación / Specification | `docs/core/algorithms/06_Data_Structures_Basics.md` |
| Rama / Branch | `feat/algorithms/data-structures-basics` |
| Commit del submódulo / Submodule commit | `602645a` |
| Árbol / Tree | limpio / clean |
| Fecha / Date | `2026-09-28T22:24:05-06:00` |

## Suite de pruebas / Test suite

````text
$ make test
./run_tests
=========================================
 DATA STRUCTURES BASICS - Unit tests
=========================================
--- Node tests ---
  [OK] node initialize and observe value should return 10                              
  [OK] node initialize and observe link should be absent                               
  [OK] node link and traverse should return 20                                         
  [OK] linked node next should be absent                                               
--- LinkedList tests ---
  [OK] linked list empty state should report empty                                     
  [OK] linked list empty state should have size 0                                      
  [OK] linked list empty state head should fail                                        
  [OK] linked list insert both ends should have size 4                                 
  [OK] linked list insert both ends should have head 5                                 
  [OK] linked list delete first occurrence should succeed                              
  [OK] linked list state should retain head 5                                          
  [OK] linked list state should retain size 3                                          
  [OK] linked list delete absent value should fail                                     
  [OK] linked list state should retain head 5                                          
  [OK] linked list state should retain size 3                                          
  [OK] linked list empty should delete head                                            
  [OK] linked list empty should delete middle                                          
  [OK] linked list empty should delete tail                                            
  [OK] linked list empty should report empty                                           
  [OK] linked list empty should have size 0                                            
  [OK] linked list empty head should fail                                              
--- Stack tests ---
  [OK] stack empty state should report empty                                           
  [OK] stack empty state should have size 0                                            
  [OK] stack empty peek should fail                                                    
  [OK] stack empty pop should fail                                                     
  [OK] stack LIFO peek should return 30                                                
  [OK] stack non-mutating peek should retain size 3                                    
  [OK] stack removal should pop 30                                                     
  [OK] stack reuse should pop 40                                                       
  [OK] stack removal should pop 20                                                     
  [OK] stack removal should pop 10                                                     
  [OK] stack removal should finish empty                                               
  [OK] stack removal should finish with size 0                                         
  [OK] stack empty after removal pop should fail                                       
  [OK] stack empty after removal should remain empty                                   
--- Queue tests ---
  [OK] queue empty state should report empty                                           
  [OK] queue empty state should have size 0                                            
  [OK] queue empty peek should fail                                                    
  [OK] queue empty dequeue should fail                                                 
  [OK] queue FIFO peek should return 10                                                
  [OK] queue non-mutating peek should retain size 3                                    
  [OK] queue removal should dequeue 10                                                 
  [OK] queue reuse should dequeue 20                                                   
  [OK] queue removal should dequeue 30                                                 
  [OK] queue removal should dequeue 40                                                 
  [OK] queue removal should finish empty                                               
  [OK] queue removal should finish with size 0                                         
  [OK] queue empty after removal dequeue should fail                                   
  [OK] queue empty after removal should remain empty                                   
 
SUMMARY:
  Total:    049
  Passed:   049
  Failed:   000
 
=========================================
 GLOBAL RESULTS
=========================================
  >>> ALL TESTS PASSED <<<
````

## Verificador / Verifier

Sin verificador para `cobol` / no verifier for `cobol`.

## Veredicto / Verdict

**verde / green** — `test` en `0`.
