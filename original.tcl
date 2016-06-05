# TCL Script for EGGDROP
# cornbread!cornbread@cornbread.me
# email: cornbread@rearend.org
#
# #TOP100 Script
set vers "3.0"
#
# 
# 
#
set topchan "#big_brother"


# COMMANDS

bind msg o !help cmd:help
bind msg o !join cmd:join
bind msg o !part cmd:part
bind msg o !rehash cmd:rehash
bind msg o !op cmd:op
bind msg o !restart cmd:restart
bind msg o !jump cmd:jump
bind msg o !version cmd:version
bind msg o !channels cmd:chans
bind msg o !ignore cmd:ignore
bind msg o !unignore cmd:uignore
bind msg o !iglist cmd:iglist
bind msg o !on cmd:on
bind msg o !off cmd:off
bind pub o !stop cmd:stop
bind pub o !part cmd:ppart
bind pub o !check cmd:check
bind pub o !names cmd:names
bind pub o !die cmd:die
bind msg o !topchan cmd:topchan

###TOPCHAN SETUP####
proc cmd:topchan {nick uhost handle text} {
	global topchan
	if {$text == ""} {
		putserv "PRIVMSG $nick :\002Relay Channel is $topchan"
	} else {
		set topchan [lindex $text 0]
		putserv "PRIVMSG $nick :\002Relay Channel is now $topchan"
	}
}

# PUBLIC COMMANDS:Procedures
# !help
proc cmd:help {nick uhost handle text} {
  global topchan vers
  putserv "PRIVMSG $nick :\002\[STATUS CHANNEL\]\002 $topchan"
  putserv "PRIVMSG $nick :\002\[VERSION\]\002 Top 100 Script v$vers"
  putserv "PRIVMSG $nick :\002\[MSG COMMANDS\]\002"
  putserv "PRIVMSG $nick :\002!topchan\002 <#channel> - setup"
  putserv "PRIVMSG $nick :\002!on\002 / \002!off\002"
  putserv "PRIVMSG $nick :\002!join\002 <#channel> - join channel"
  putserv "PRIVMSG $nick :\002!part\002 <#channel> - part channel"
  putserv "PRIVMSG $nick :\002!rehash\002 - rehash bot"
  putserv "PRIVMSG $nick :\002!op\002 <nick> <#channel> - op user in channel"
  putserv "PRIVMSG $nick :\002!restart\002 - restarts the bot"
  putserv "PRIVMSG $nick :\002!jump\002 - jump to next server"
  putserv "PRIVMSG $nick :\002!version\002 - current version"
  putserv "PRIVMSG $nick :\002!channels\002 - list bot's channels"
  putserv "PRIVMSG $nick :\002!say\002 <#channel> <text> - says text to channel"
  putserv "PRIVMSG $nick :\002!isay\002 <#channel> <text> - says text to channel as you"
  putserv "PRIVMSG $nick :\002!ignore\002 <host> <time> <reason> - adds host to bot's ignore list"
  putserv "PRIVMSG $nick :\002!uignore\002 <host> - removes host from bot's ignore list"
  putserv "PRIVMSG $nick :\002\[$topchan COMMANDS\]\002"
  putserv "PRIVMSG $nick :\002!part\002 - part channel"
  putserv "PRIVMSG $nick :\002!sleep\002 - Stops all relaying"
  putserv "PRIVMSG $nick :\002!check\002 <#channel> - checks to see if bot is on channel"
  putserv "PRIVMSG $nick :\002!names\002 <#channel> - list who is on channel"
  putserv "PRIVMSG $nick :\002!die\002 - bot dies"
}
# !join <#channel>
proc cmd:join {nick uhost handle text} {
  channel add $text
  puthelp "PRIVMSG $nick :\002\00303\[$text ADDED\]\00301\002"
}
# !part <#channel>
proc cmd:part {nick uhost handle text} {
  channel remove $text
  puthelp "PRIVMSG $nick :\002\00303\[$text REMOVED\]\00301\002"
}
# !rehash
proc cmd:rehash {nick uhost handle text} {
  rehash
  putserv "PRIVMSG $nick :\002\00303\[REHASHED\]\00301\002"
}
# !op <nick> <channel>
proc cmd:op {nick uhost handle text} {
  set who [lindex $text 0]
  set where [lindex $text 1]
  putserv "MODE $who +o $where"
}
# !restart
proc cmd:restart {nick uhost handle text} {
  restart
}
# !jump
proc cmd:jump {nick uhost handle text} {
  jump
}
# !version
proc cmd:version {nick uhost handle text} {
  global vers
  putserv "PRIVMSG $nick :\002\[Top100 v$vers\]\002"
}
# !channels
proc cmd:chans {nick uhost handle text} {
  puthelp "PRIVMSG $nick :\002\00303\[CHANNEL LIST\]\00301\002"
  foreach channel [channels] {
    puthelp "PRIVMSG $nick :$channel"
  }
puthelp "PRIVMSG $nick :\002\00303\[END OF LIST\]\00301\002"
}
# !ignore
proc cmd:ignore {nick uhost handle text} {
  set who [lindex $text 0] 
  set igtime [lindex $text 1]
  set reason [lindex $text 2 end]
  if {[isignore $who] == 0} {
    newignore $who $nick $reason $igtime
    putquick "PRIVMSG $nick :\002\[IGNORE ADDED\]\002"
  }
}
#  !uignore
proc cmd:uignore {nick uhost handle text} {
  set who [lindex $text 0]
  if {[isignore $who] == 1} {
    killignore $who
    putquick "PRIVMSG $nick :\002\[IGNORE REMOVED\]\002"
  }
}
# !iglist
proc cmd:iglist {nick uhost handle text} {
  puthelp "NOTICE $nick :\002\[IGNORE LIST\]\002"
  foreach ignore [ignorelist] {
    puthelp "NOTICE $nick :$ignore"
  }
  puthelp "NOTICE $nick :\002\[END OF LIST\]\002" 
}

# !part
proc cmd:ppart {nick uhost handle chan text} {
  channel remove $chan
  puthelp "PRIVMSG $nick :\002\00303\[$chan REMOVED\]\00301\002"
}

# !check <#channel>
proc cmd:check {nick uhost hand chan text} {
  global topchan
  set where [lindex $text 0]
  set where [botonchan $where]
  if {$where == 1} {
    puthelp "PRIVMSG $topchan :\002Yes, I'm on $text\002"
  }
}

# !names <#channel>
proc cmd:names {nick uhost hand chan text} {
  global topchan
  set where [lindex $text 0]
  if {[botonchan $where] == 1} {
    set lnames [chanlist $where]
    puthelp "PRIVMSG $topchan :\002\[$where\]\002 - $lnames"
  }
}

# !die
proc cmd:die {nick uhost hand chan text} {
  if {$chan != $topchan} {
    die
  }
}

########STOP THE SYSTEM############ 
proc cmd:off {nick uhost handle text} {
  clearqueue all
  unbind pubm - * bind:pubm
  unbind kick - * bind:kick
  unbind ctcp - ACTION bind:action
putserv "PRIVMSG $nick :\002\00304\[STATUS SYSTEM SHUT DOWN\]\00301\002"
}
#
proc cmd:stop {nick uhost handle chan text} {
  global topchan

  if {$chan == $topchan} {
    clearqueue all
    unbind pubm - * bind:pubm
    unbind kick - * bind:kick
    unbind ctcp - ACTION bind:action
    putserv "PRIVMSG $topchan :\002\00304\[GOING TO SLEEP\]\00301\002"
  }
}

##########STARTS THE SYSTEM##########
proc cmd:on {nick uhost handle text} {
  bind pubm - * bind:pubm
  bind kick - * bind:kick
  bind ctcp - ACTION bind:action
  putserv "PRIVMSG $nick :\002\00303\[STATUS SYSTEM STARTED\]\00301\002"
  
  proc bind:action {nick uhost hand dest keyword text} {
    global topchan
    putserv "PRIVMSG $topchan :\002\[$keyword\]\002 \00303$nick $text\00301"
  }
  
  # if the bot gets kicked & remove channel
  proc bind:kick {nick uhost hand chan target reason} {
    global topchan
    if {[isbotnick $target] == 1} {
      putserv "PRIVMSG $topchan :\002\[KICKED FROM $chan for $reason\]\002"
      channel remove $chan
    }
  }
  
  # Channel messasges from all channels except status channel.
  proc bind:pubm {nick uhost hand chan text} {
    global topchan
    if {$chan != $topchan} {
      if {[isop $nick $chan] == 1} {
        set opd "@"
      }
      if {[isvoice $nick $chan] == 1} {
        set opd "+"
      }
      if {[isop $nick $chan] == 0 && [isvoice $nick $chan] == 0} {
        set opd ""
      }
    putserv "PRIVMSG $topchan :\002\[$chan\]\002 \00303<$opd$nick>\00301 $text"
    }
  }
}
#


putlog "\[TOP100 Script version $vers and $topchan\]"
#
# EOF
