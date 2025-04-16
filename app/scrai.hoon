/-  *scrai
/+  dbug, default-agent, server, schooner
/*  ui  %html  /app/scrai/html
::
|%
+$  versioned-state  $%(state-0)
+$  state-0
  $:  %0 
      data=(list path) 
      response=@t
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
  =^  cards  state  abet:(arvo:hc [wire sign-arvo])
  [cards this]
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
      %scrai-action
    =/  act  !<(action +.cage)
    (handle-action act)
  ==
::
::  User poke from frontend.
++  handle-action
  |=  act=action
  ^+  that
  ?-    -.act
      %send
    =/  text
      %-  crip
      ;:  weld
        (trip text.message.act)
        " FILE NAME: "
        `tape`path.message.act
        " FILE CONTENTS: "
        .^((list @t) %cx (weld /(scot %p our.bowl)/scrai/(scot %da now.bowl) path.message.act))
      ==
    ~&  >>  text
    %-  emit
    ^-  card
    :*  %pass 
        /chat/(scot %da now.bowl)
        %arvo 
        %i
        %request 
        (llm-request text) 
        *outbound-config:iris
    ==
  ==
::
::  Create the outgoing LLM HTTP request
::  according to OpenAI API.
++  llm-request
  |=  text=@t
  ^-  request:http
  :*  %'POST'
      'http://localhost:11434/v1/chat/completions'
      :~  ['Content-Type' 'application/json']
          :: ['Authorization' 'Bearer 3QCDCG0-NJZ4X04-PMRR7CF-MT0BJ96']
      ==
  ::
      :-  ~
      =/  messages
        :~  [`who`%system prompt]
            [`who`%user text]
        ==
      %-  json-to-octs:server
      ^-  json
      %-  pairs:enjs:format
      :~  [%model s+'llama3.2:latest']
          [%stream b+%.n]
          [%temperature n+'0.7']
          :-  %messages
          :-  %a
          %+  turn
            messages
          |=  [=who what=@t]
          ^-  json
          %-  pairs:enjs:format
          :~  [%role s+who]
              [%content s+what]
          ==
      ==
  ==
::
::  Receive response from LLM.
++  arvo
  |=  [=wire sign=sign-arvo]
  ^+  that  
  ~&  >  sign
  ?.  ?=([%iris %http-response *] sign)  that
  =/  reply=@t  (response-to-reply client-response.sign)
  that(response reply)
::
::  Parse LLM response.
++  response-to-reply
  |=  response=client-response:iris
  ^-  @t
  ?+    -.response  !!
      %finished
    =/  mime  (need full-file.response)
    =/  =json  (need (de:json:html q.data.mime))
    ~&  >>  json
    ?+    -.json  !!
        %o
      =/  kson  (~(got by p.json) 'choices')
      ?+    -.kson  !!
          %a
        =/  lson  (snag 0 p.kson)  
        ?+    -.lson  !!
            %o
          =/  mson  (~(got by p.lson) 'message')
          ?+    -.mson  !!
              %o
            =/  replyson  (~(got by p.mson) 'content')
            ?+    -.replyson  !!
                %s
              p.replyson
            ==
          ==
        ==
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
      %'POST'
    ?+    site  that
        [%scrai ~]
      =/  =json  (need (de:json:html q:(need body.request.inbound-request)))
      =/  act=action  (dejs-post json)
      =.  that  (handle-action act)
      %-  emil  %-  flop  %-  send
      [200 ~ [%none ~]]
    ==
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
    :-  %response
    [%s response]
  ==
::
++  dejs-post
  =,  dejs:format
  |=  jon=json
  ^-  action
  %.  jon
  %-  of
  :~  [%send (ot ~[text+so path+pa])]
  ==
::
++  prompt
  '''
  You are a helpful AI assistant. The user will be messaging you with
  some text (their message) and a file from their
  Urbit ship, which will be labelled by file name and contain the full
  contents. Use these contents when responding.

  You will only receive a single message before conversational context is reset,
  so respond as in-depth as possible; no clarifying questions.

  The format of the message will be:

  <message text from user> FILE NAME: <file name> FILE CONTENTS: <file contents>
  '''
::
--
