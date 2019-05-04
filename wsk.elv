use epm
epm:install github.com/zzamboni/elvish-completions
use github.com/zzamboni/elvish-completions/comp
use re

# OpenWhisk CLI

# Available Commands:
#   action      work with actions
#   activation  work with activations
#   package     work with packages
#   rule        work with rules
#   trigger     work with triggers
#   sdk         work with the sdk
#   property    work with whisk properties
#   namespace   work with namespaces
#   list        list entities in the current namespace
#   api         work with APIs
#   project     The OpenWhisk Project Management Tool

wsk-flags = [apihost apiversion auth cert debug help insecure key verbose]

action-flags = [annotation annotation-file concurrency copy docker kind logsize main memory native param param-file sequence timeout web web-secure]

fn -wsk-actions []{
  comp:item [(wsk action list | drop 1 | each [line]{ re:split "(\\s+)" $line | take 1 | comp:decorate &style="green" })]
}

fn -wsk-packages []{
  comp:item [(wsk package list | drop 1 | each [line]{ re:split "(\\s+)" $line | take 1 | comp:decorate &style="magenta" })]
}

fn -wsk-activations []{
  comp:item [(wsk activation list | drop 1 | each [line]{ re:split "(\\s+)" $line | take 3 | drop 2 | comp:decorate &style="blue" &display-suffix="foo" }) (comp:decorate &style="cyan" --last)]
}

fn -wsk-funky-activations []{
  comp:item [(wsk activation list | drop 1 | each [line]{ 
    struct = [(re:split "(\\s+)" $line)]; 
    found = (re:find "^(......)(.*)$" $struct[2]); 
    end = $found[groups][2][text];
    start = $found[groups][1][text];
    display-suffix = (joins " " ["… at" $struct[0] $struct[1]]);
    comp:decorate &style="blue" &display-suffix=$display-suffix &code-suffix=$end $start })
    (comp:decorate &style="cyan" --last)]
}

wsk-completions = [
  &action= (comp:subcommands [ 
    &create= (comp:sequence &opts=$action-flags  [])
    &update= (comp:sequence &opts=$action-flags [(-wsk-actions)])
    &invoke= (comp:sequence &opts=[blocking param param-file result] [(-wsk-actions)])
    &get= (comp:sequence &opts=[save save-as summary url] [(-wsk-actions)])
    &delete= (-wsk-actions)
    &list= (comp:sequence &opts=[limit name-sort skip] [(-wsk-packages)])])
  &activation= (comp:subcommands [ 
    &list= (comp:sequence &opts=[full limit skip since upto] [(-wsk-actions)])
    &get= (comp:sequence &opts=[last summary] [(-wsk-funky-activations)])
    &logs= (comp:sequence &opts=[last strip] [(-wsk-funky-activations)])
    &result= (comp:sequence &opts=[last] [(-wsk-funky-activations)])
    &poll= ])
  &package= (comp:subcommands [ 
    &bind=
    &create= 
    &update= (comp:sequence &opts=[annotation annotation-file param param-file shared] [(-wsk-packages)])
    &get= (comp:sequence &opts=[summary] [(-wsk-packages)])
    &delete= (comp:sequence [(-wsk-packages)])
    &list= (comp:sequence &opts=[limit name-sort skip] [])
    &refresh= ])
  &rule=
  &trigger=
  &sdk=
  &property=
  &namespace=
  &list=
  &api=
  &project=
]

edit:completion:arg-completer[wsk] = (comp:subcommands &opts=$wsk-flags $wsk-completions)

# work with actions
# Usage:
#   wsk action [command]

# Available Commands:
#   create      create a new action
#   update      update an existing action, or create an action if it does not exist
#   invoke      invoke action
#   get         get action
#   delete      delete action
#   list        list all actions in a namespace or actions contained in a package

# work with activations
# Usage:
#   wsk activation [command]

# Available Commands:
#   list        list activations
#   get         get activation
#   logs        get the logs of an activation
#   result      get the result of an activation
#   poll        poll continuously for log messages from currently running actions

# work with packages
# Usage:
#   wsk package [command]

# Available Commands:
#   bind        bind parameters to a package
#   create      create a new package
#   update      update an existing package, or create a package if it does not exist
#   get         get package
#   delete      delete package
#   list        list all packages
#   refresh     refresh package bindings

