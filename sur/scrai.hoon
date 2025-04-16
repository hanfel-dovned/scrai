|%
+$  who  ?(%system %user %assistant)
+$  message  [text=@t paths=(list path)]
+$  do  :: user poke from frontend to %scrai
  $%  [%send =message]
  ==
+$  request  :: poke from %scrai to %llm
  $%  [%request =message]
  ==
+$  response  :: poke from %llm to %scrai
  $%  [%response text=@t]
  ==
--