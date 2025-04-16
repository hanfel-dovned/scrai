/-  *scrai
/+  dbug, default-agent, server, schooner
/*  ui  %html  /app/scrai/html
::
|%
+$  versioned-state  $%(state-0)
+$  state-0
  $:  %0 
      data=(list path) 
      responses=(list @t)
      waiting=(list path)
  ==
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
::
=<
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
    hc   ~(. +> [bowl ~])
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state  abet:init:hc
  [cards this]
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  =vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 vase))]
::
++  on-poke
  |=  =cage
  ^-  (quip card _this)
  =^  cards  state  abet:(poke:hc cage)
  [cards this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  [~ ~]
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  `this
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  =^  cards  state  abet:(watch:hc path)
  [cards this]
::
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
::
|_  [=bowl:gall deck=(list card)]
+*  that  .
::
++  emit  |=(=card that(deck [card deck]))
++  emil  |=(lac=(list card) that(deck (welp lac deck)))
++  abet  ^-((quip card _state) [(flop deck) state])
::
++  init
  ^+  that
  =.  data  
    .^((list path) %ct /(scot %p our.bowl)/scrai/(scot %da now.bowl)/fil)
  %-  emit
  :*  %pass   /eyre/connect   
      %arvo  %e  %connect
      `/scrai  %scrai
  ==
::
++  watch
  |=  =path
  ^+  that
  ?+    path  that
      [%http-response *]
    that
  ==
:: 
++  poke
  |=  =cage
  ^+  that
  ?+    -.cage  !!
      %handle-http-request
    (handle-http !<([@ta =inbound-request:eyre] +.cage))
  ::
      %scrai-do
    =+  !<(=do +.cage)
    ?-    -.do
        %send
      ::?:  (gth (lent waiting) 0)  that
      =.  waiting  paths.message.do
      %-  emil
      %+  weld
      ::  Whitelist paths for ~ridlyd.
      %+  turn
        waiting
      |=  =path
      ^-  card
      :*  %pass  (weld /white path)  %arvo  %c
          %perm  %scrai  path  %r  
          ~   %white  (sy [%.y ~ridlyd]~)
      ==
      ::  Poke ~ridlyd.
      :~  ^-  card
          :*  %pass  /request  %agent
              [~ridlyd %llm]
              %poke  %scrai-request 
              !>([%request message.do])
          ==
      ==
    ==
  ::
      %scrai-response
    =+  !<(=response +.cage)
    ?-    -.response
        %response
      ?:  =(0 (lent waiting))  that
      =/  paths  waiting
      =.  waiting   ~
      =.  responses  [text.response responses]
      ::  Remove ~ridlyd's permissions.
      %-  emil
      %+  turn
        waiting
      |=  =path
      ^-  card
      :*  %pass  (weld /remove path)  %arvo  %c
          %perm  %scrai  path  %r  
          ~   %white  ~
      ==
    ==
  ==
::
++  handle-http
  |=  [eyre-id=@ta =inbound-request:eyre]
  ^+  that
  =/  ,request-line:server
    (parse-request-line:server url.request.inbound-request)
  =+  send=(cury response:schooner eyre-id)
  ::
  ?+    method.request.inbound-request
    (emil (flop (send [405 ~ [%stock ~]])))
  ::
      %'GET'
    %-  emil  %-  flop  %-  send
    ?+    site  [404 ~ [%plain "404 - Not Found"]]
    ::
        [%scrai ~]
      [200 ~ [%html ui]]
    ::
        [%scrai %state ~]
      [200 ~ [%json enjs-state]]
    ==
  ==
::
++  enjs-state
  ^-  json
  %-  pairs:enjs:format
  :~
    :-  %data
    :-  %a
    %+  turn
      data
    |=  =path
    (path:enjs:format path)
  ::
    :-  %responses
    :-  %a
    %+  turn
      responses
    |=  text=@t
    [%s text]
  ==
--
