Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")";
	cd "$HERE"
	paste <(echo {1..26} | tr ' ' '\n') <(echo {A..Z} | tr ' ' '\n') > Names.tsv
	sqlite3 -batch -interactive Names.db < create_Names.sql
	sqlite3 -batch -interactive Names.db '.mode tabs' '.import Names.tsv Names'
	sqlite3 -batch -interactive Names.db '.mode tabs' '.headers on' 'select * from Names'
	sqlite3 -batch -interactive Names.db \
		'.trace stdout' \
		'.headers on' \
		'.mode tabs' \
		'select * from Names where Id in (select Id from Names order by random() limit 5)'
}
Run "$@"
