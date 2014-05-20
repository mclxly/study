import time, getpass
import datetime
import sublime, sublime_plugin

class AddDateTimeCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		#generate the timestamp
		timestamp_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

		self.view.run_command("insert_snippet", { "contents": "%s" %  timestamp_str } )