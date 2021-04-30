# fluent-bit demo: broken array output for lua filter

Lua returns broken output if given an array with a null key in it.


## Steps to reproduce

Given the following input file with a JSON struture that contains an array with a null key in the middle:

```js
// broken.json
{
  "hello": [1, null, "world"]
}
```

A no-op lua function that just returns its input:
```lua
function lua_noop(tag, timestamp, record)
    return 1, timestamp, record
end
```

And the following fluent-bit config that reads from stdin, filters through the lua no-op function, and output to sdout:

```conf
[INPUT]
    Name stdin

[FILTER]
    Name   lua
    Match  *
    Script /scripts/functions.lua
    Call   lua_noop

[OUTPUT]
    Name stdout
    Match *
    Format json_stream
```

You can run `make` after cloning this repo to test this setup.

When running this, I expect the following output:

```json
{"date":1619774312.484865,"hello":[1,null,"world"]}
```

But instead get:

```json
{"date":1619774347.885416,"hello":{1:1,3:"world"}}
```

Which is not valid JSON because the array is turned into an object with integer keys, and breaks downstream filters / outputs.
