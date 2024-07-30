#!/usr/bin/env zsh
# uploads data and fetch URL from the pastebin http://sprunge.us
# the code is taken from ohmyzsh  https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sprunge
# i have modified the script for cleaner output and to automatically copy the url into clipboard if clipcopy is installed.
sprunge() {
  if [[ "$1" = "--help" ]]; then
    fmt -s >&2 << EOF

DESCRIPTION
  Upload data and fetch URL from the pastebin http://sprunge.us

USAGE
  $0 filename.txt
  $0 text string
  $0 < filename.txt
  piped_data | $0

NOTES
  Input Methods:
  $0 can accept piped data, STDIN redirection [< filename.txt], text strings following the command as arguments, or filenames as arguments. Only one of these methods can be used at a time, so please see the note on precedence. Also, note that using a pipe or STDIN redirection will treat tabs as spaces, or disregard them entirely (if they appear at the beginning of a line). So I suggest using a filename as an argument if tabs are important either to the function or readability of the code.

  Precedence:
  STDIN redirection has precedence, then piped input, then a filename as an argument, and finally text strings as arguments. For example:

    echo piped | $0 arguments.txt < stdin_redirection.txt

  In this example, the contents of file_as_stdin_redirection.txt would be uploaded. Both the piped_text and the file_as_argument.txt are ignored. If there is piped input and arguments, the arguments will be ignored, and the piped input uploaded.

  Filenames:
  If a filename is misspelled or doesn't have the necessary path description, it will NOT generate an error, but will instead treat it as a text string and upload it.

EOF
    return
  fi
    if [ -t 0 ]; then
	if [ "$*" ]; then
	    if [ -f "$*" ]; then
		echo Uploading "$*"... >&2
		url="$(cat "$*" | curl -F 'sprunge=<-' http://sprunge.us)"
		if command -v clipcopy &>/dev/null; then 
		    echo $url | clipcopy
		    echo "Url was copied to your clipboard"
		fi
		echo $url
	    else
		echo File "$*" does not exist.
	    fi
	else
	    sprunge --help
	    return 1
	fi
    else
	echo Uploading STDIN... >&2
	url="$(curl -F 'sprunge=<-' http://sprunge.us)"
	if command -v clipcopy &>/dev/null; then 
	    echo $url | clipcopy
	    echo "Url was copied to your clipboard"
	fi
	echo $url
    fi
}
