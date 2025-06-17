|%
+$  who  ?(%system %user %assistant)
+$  message  [=who what=@t]
+$  messages  ((mop @da message) gth)
::
+$  action  :: user poke
  $%  [%send text=@t]
      [%run =cord]
      [%set-llm-url url=@t]
      [%set-llm-auth auth=@t]
      [%set-llm-model model=@t]
  ==
--