/-  *scrai
/+  dbug, default-agent, server, schooner
/*  ui  %html  /app/scrai/html
::
|%
+$  versioned-state  $%(state-0)
+$  state-0
  $:  %0 
      data=(list path) 
      =messages
      llm-url=@t
      llm-auth=@t
      llm-model=@t
  ==
+$  card  card:agent:gall
++  orm  ((on @da message) gth)
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
  =.  llm-model  'gpt-4o'
  =.  llm-url  'https://api.openai.com/v1/chat/completions'
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
::  User poke
++  handle-action
  |=  act=action
  ^+  that
  ?-    -.act
  ::
  ::  Set URL endpoint for LLM request.
      %set-llm-url
    that(llm-url url.act)
  ::
  ::  Set auth header / API key for LLM request.
      %set-llm-auth
    that(llm-auth auth.act)
  ::
  ::  Set model name for LLM request.
      %set-llm-model
    that(llm-model model.act)
  ::
  ::  Send a message to the LLM.
      %send
    %-  emit
    ^-  card
    :*  %pass 
        /chat/(scot %da now.bowl)
        %arvo 
        %i
        %request 
        (llm-request text.act) 
        *outbound-config:iris
    ==
  ::
  ::  Run a poke.
      %run
    %-  emit
    ~&  >>  cord.act
    !<  card:agent:gall  
    (slap !>([bowl=bowl ..zuse]) (ream cord.act))
  ==
::
::  Create the outgoing LLM HTTP request
::  according to OpenAI API.
++  llm-request
  |=  text=@t
  ^-  request:http
  :*  %'POST'
      llm-url
      :~  ['Content-Type' 'application/json']
          ['Authorization' llm-auth]
      ==
  ::
      :-  ~
      =/  msgs
        :-  [`who`%system prompt]
        %-  flop 
        %+  turn 
          (tap:orm messages)
        |=([@da =message] message)
      %-  json-to-octs:server
      ^-  json
      %-  pairs:enjs:format
      :~  [%model s+llm-model]
          [%stream b+%.n]
          [%temperature n+'0.7']
          :-  %messages
          :-  %a
          %+  turn
            msgs
          |=  [=who what=@t]
          ^-  json
          %-  pairs:enjs:format
          :~  [%role s+who]
              [%content s+what]
          ==
      ==
  ==
::
::  Receive and process an LLM response.
++  arvo
  |=  [=wire sign=sign-arvo]
  ^+  that  
  ~&  >  sign
  ?.  ?=([%iris %http-response *] sign)  that
  =/  =time  (from-unix-ms:chrono:userlib (unm:chrono:userlib now.bowl))
  ::
  :: Convert the HTTP response to a raw message and append.
  =/  reply=@t  
    (response-to-reply client-response.sign)
  =.  messages  (put:orm messages time [%assistant reply])
  ::
  ::  Convert the raw message to JSON.
  ::  Based on the key, potentially run a command and append results.
  =;  results=(unit message)
    ?~  results  that
    that(messages (put:orm messages (add 1 time) u.results))
  =/  error
    :-  ~ 
    :-  %user 
    'URBIT RESPONSE: The LLM\'s response was not formatted as expected JSON.'
  =/  reply-json  (de:json:html reply)
  ?~  reply-json  error
  =/  json  u.reply-json
  ?+    -.json  error
      %o
    ::
    ::  "message" - do nothing (we already appended it)
    ?:  (~(has by p.json) 'message')  ~
    ::
    ::  "poke" - do nothing (user runs this later)
    ?:  (~(has by p.json) 'poke')  ~
    ::
    ::  "scry" - perform the scry and inject contents
    ?:  (~(has by p.json) 'scry')
    =/  scryson  (~(got by p.json) 'scry')
    ?+    -.scryson  error
        %s
      ~  :: XX figure out what exactly this cord should encode, maybe this should be an object actually
    ==
    ::
    ::  catch other cases
    error
  ==
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
    :-  %messages
    :-  %a
    %+  turn
      (flop (tap:orm messages))
    |=  [time=@da [=who text=cord]]
    ^-  json
    %-  pairs:enjs:format
    :~  [%time s+(scot %ud (unm:chrono:userlib time))]
        [%text s+text]
        [%who s+who]
    ==
  ==
::
++  dejs-post
  =,  dejs:format
  |=  jon=json
  ^-  action
  %.  jon
  %-  of
  :~  [%send (ot ~[text+so])]
      [%run (ot ~[cord+so])]
      [%set-llm-url (ot ~[url+so])]
      [%set-llm-auth (ot ~[auth+so])]
      [%set-llm-model (ot ~[model+so])]
  ==
::
++  prompt
  '''
  A user is accessing you via their Urbit ship and may be expecting you to perform an action on their ship for them.

  ---------

  Some Urbit docs:
  
  "Pokes are requests, actions, or just some data which you send to another agent. Unlike subscriptions, these are just one-off messages.
  A %poke contains a cage of some data. A cage is a cell of [mark vase]. The mark is just a @tas like %foo, and corresponds to a mark file in the /mar directory. We'll cover marks in greater detail later. The vase contains the actual data you're sending."

  Here's the template:

  [%pass /some/wire %agent [~some-ship %some-agent] %poke %some-mark !>(data)]

  So, to break this down, a poke is a type of card. That card is a tuple of:
  - %pass
  - a wire, aka a path, that we'll receive an ack on. this can be arbitrary and we'll just use a generic one
  - %agent (if we're poking a gall agent, which we will be)
  - a cell of ship and agent. for our use cases, you will simply write "our.bowl" in place of the ship, which will populate the ship field with the user's ship. you will be told the specific agent to poke
  - %poke
  - %some-mark
  - !>(data)

  So the parts that vary here are the agent, the mark, and the vase. Our template, then, becomes:

  [%pass /ai %agent [our.bowl %some-agent] %poke %some-mark !>(data)]

  When the users asks you to perform an action, you are going to respond ONLY with text formatted as JSON:
  
  {poke: <poke-card>}

  <poke-card> should be replaced with the template tuple above, with agent name, mark, and data filled in.
  Now, I am going to document all of the different pokes that you'll have access to per agent.

  --------

  %links

  An Urbit app that lets you host a page of links from your ship.

  Has the following type definitions:
  
  |%
  +$  link  [url=@t text=@t image-url=@t]
  +$  action  
    $%  [%new =link]
        [%delete index=@ud]
        [%reorder current=@ud new=@ud]
    ==
  --

  So, examples of the cards that you can send will be:
  
  [%pass /ai %agent [our.bowl %links] %poke %links-action !>([%new 'http://google.com' 'Google' 'http://google.com/google-logo'])]
  Adds a link to the user's links.

  We won't implement the delete and reorder actions now, since that would require you to have access to the state of the app.

  ---------

  This preamble will be prepended to either the system prompt, or the user's first message, or every message that they send you. Your job is to either respond to them normally, or, if they ask you to perform an action, respond with the JSON as we discussed earlier.
  
  INCORRECT:
  {
    "poke": [
      "%pass",
      "/ai",
      "%agent",
      ["our.bowl", "%links"],
      "%poke",
      "%links-action",
      "!>([%new 'https://x.com' 'X' 'https://x.com/favicon.ico'])"
    ]
  }

  CORRECT:
  {
    "poke": "[%pass /ai %agent [our.bowl %links] %poke %links-action !>([%new 'https://x.com' 'X' 'https://x.com/favicon.ico'])]"
  }

  Notes for Next Version, disregard this paragraph: If the user makes a vague request, you can ask for clarification before responding with JSON. For instance, if they ask to add "a link to their X profile" without telling you what their account name is, you should ask what their account name is before guessing the link they want. If they ask to change the color of some background somewhere, ask which color rather than guessing, unless they seem to want you to just randomly change it.

  If the user does not seem to want you to perform an action, respond with a regular message. When responding with a regular message, respond with:
  {
    "message": <response-text>
  }

  Be sure to ONLY respond with the JSON object as formatted in the way we discussed. Do not continue beyond the curly braces.

  ---------

  Additionally, the user may include the contents of a file from their Urbit ship, which will be labelled by file name and contain the full contents. Use these contents when responding.

  The format of the message will be:

  <message text from user> FILE NAME: <file name> FILE CONTENTS: <file contents>

  -----------
  '''
::
--