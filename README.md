# %scrai

`%scrai` is a prototype for AI features on Urbit.

- Connect to a running LLM by providing an API key.
- Read files from Clay and include them in LLM queries.
- Have the LLM generate actions to run on your ship (with your approval).

## Installation

1. Install the contents of `desk` to a ship.
2. Point your %scrai agent at an OpenAI API endpoint using the following pokes:
- `:scrai &scrai-action [%set-llm-url 'model-url']`, where `model-url` is typically something like `https://api.openai.com/v1/chat/completions`.
- `:scrai &scrai-action [%set-llm-model 'model-name']`, where `model-name` is the name of the model you're using, e.g. `gpt-4o`
- `:computeer &scrai-action [%set-llm-auth 'api-key']`, where `api-key` typically looks like `Bearer sk-proj-asdlfkjasldkfj...`.

## Philosophy

It makes significantly more sense to implement Owen Barnes' ["Future of Apps"](https://youtu.be/QU0Ml0ihds0?si=oVQFYv-yuuGK3_jR&t=3258) concept on Urbit—a deterministic system made up of protocols with well-defined actions—than it does to try and train an image-recognition model to control a cursor on your desktop.