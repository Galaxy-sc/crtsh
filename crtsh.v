import net.http
import os
import flag
import regex

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.skip_executable()
	
	url := fp.string(
		'url',
		`u`,
		'no text',
		'Domain name -u site.com'
	)

	fp.finalize() or {
		eprintln(err)
		println(fp.usage())
		return
	}

	response := http.get('https://crt.sh/?q=$url') or {panic(err)}

	// Regex
	reg := r'[a-zA-Z0-9\-.]+\.' + url
	mut re := regex.regex_opt(reg) or {panic(err)}
	final := re.find_all_str(response.str())

	// Removes duplicates
	mut all_list := []string {}
    for word in final { 
    	if all_list.any(it == word.str()) == false {
			all_list << word
			println(word)
   		}
	}
}