/-  *scrai
/+  default-agent, dbug, server, schooner
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  
  $:  %0
      waiting=@t
  ==
+$  card  card:agent:gall
--
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
  [~ this]
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
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
++  emol  |=  lac=(list card)  (emil (flop lac))
++  abet  ^-((quip card _state) [(flop deck) state])
::
++  init
  ^+  that 
  that
::
++  watch
  |=  =path
  ^+  that
  ?+    path  that
    [%http-response *]  that
  ==
::
++  poke
  |=  [=mark =vase]
  ^+  that
  ?+    mark  !!
      %handle-http-request
    that
  ::
      %scrai-request
    =/  req  !<(request vase)
    (handle-request req)
  ==
::
++  handle-request
  |=  req=request
  ^+  that
  ?-    -.req
      %request
    =.  waiting  text.message.req
    ::  XX remote scry paths.message.req
    that
  ==
::
::
::  Create the outgoing LLM HTTP request
::  according to OpenAI API.
++  llm-request
  |=  text=@t
  ^-  request:http
  :*  %'POST'
      'http://localhost:11434/v1/chat/completions'
      :~  ['Content-Type' 'application/json']
          ['Authorization' 'Bearer 3QCDCG0-NJZ4X04-PMRR7CF-MT0BJ96']
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
::  Forward a response from LLM to %scrai.
++  arvo
  |=  [=wire sign=sign-arvo]
  ^+  that
  ::  XX handle remote scry response
  ::  convert files to text and then weld text to waiting
  ::  =/  text  (weld (trip waiting) ...)
  ::  %-  emit
  ::  ^-  card
  ::  :*  %pass 
  ::      /chat/(scot %p src.bowl)
  ::      %arvo 
  ::      %i
  ::      %request 
  ::      (llm-request text) 
  ::      *outbound-config:iris
  ::  ==
  ::
  ?.  ?=([%iris %http-response *] sign)  that
  =/  host=@p  `@p`(slav %p +6:wire)
  =/  reply=@t  (response-to-reply client-response.sign)
  ~&  >  reply
  %-  emit
  :*  %pass  /response  %agent
      [host %scrai]  
      %poke  %scrai-response 
      !>([%response reply])
  ==
::
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
++  prompt
  '''
  You are a helpful AI assistant. The user will be messaging you with
  some text (their message) and potentially a set of files on their
  Urbit ship, which will be labelled by file name and contain the full
  contents. Use these contents when responding.

  You will only receive a single message before conversational context is reset,
  so respond as in-depth as possible; no clarifying questions.
  '''
--