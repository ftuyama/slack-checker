## Slack Checker

First, generate a Slack API token using https://api.slack.com/custom-integrations/legacy-tokens

Set up SLACK_TOKEN and SLACK_CHANNEL env variables, so that Slack checker may fetch members list and send the
output to a custom slack channel.


### Running checker

Run once to get alive members list.

```ruby
ruby check.rb
```

Run again and checks members who died:

```ruby
ruby check.rb
```

Sample output:
```
$ ruby check.rb

                      :::!~!!!!!:.
                  .xUHWH!! !!?M88WHX:.
                .X*#M@$!!  !X!M$$$$$$WWx:.
               :!!!!!!?H! :!$!$$$$$$$$$$8X:
              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:
             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!
             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!
               !:~~~ .:!M"T#$$$$WX??#MRRMMM!
               ~?WuxiW*`   `"#$$$$8!!!!??!!!
             :X- M$$$$       `"T#$T~!8$WUXU~
            :%`  ~#$$$m:        ~!~ ?$$$$$$
          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"
.....   -~~:<` !    ~?T#$$@@W@*?$$      /`
W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :
#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`
:::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~
.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `
Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!
$R@i.~~ !     :   ~$$$$$B$$en:``
?MXT@Wx.~    :     ~"##*$$$$M~


    OMG!


2019-03-28 16:54:28 felipe.tuy IS GONE!!!!
```

### Graveyard check

One can check last month deaths using:

```
ruby graveyard.rb
```

### Headcount check

One can check headcount diff using:

```
ruby headcount.rb
```

### New members check

One can check new slack members using:

```
ruby news.rb
```
