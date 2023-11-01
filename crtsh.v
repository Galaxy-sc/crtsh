import net.http
import net.html
import os
import flag

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

	mut sub := []string {}

	response := http.get('https://crt.sh/?q=$url') or {panic(err)}
    doc := html.parse(response.body)
    tag := doc.get_tags(name: 'td')
	tag1 := doc.get_tags(name: 'br')
	
	for i in tag { // Extracts all the contents of the " td " tag
		if i.content.contains(url) {
			sub << i.content
		}
	}

	for i in tag1 { // Extracts all the contents of the " br " tag
		if i.content.contains(url) {
			sub << i.content
		}
	}

	mut all_list := []string {}

    for word in sub { // Removes duplicates
    	if all_list.any(it == word.str()) == false {
			all_list << word
			println(word)
   		}
	}

}