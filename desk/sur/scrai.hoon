|%
+$  who  ?(%system %user %assistant)
+$  message  [text=@t =path]
+$  action  :: user poke
  $%  [%send =message]
      [%run =cord]
      [%set-llm-url url=@t]
      [%set-llm-auth auth=@t]
      [%set-llm-model model=@t]
  ==
--