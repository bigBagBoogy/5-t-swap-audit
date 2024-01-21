import re

latex_commands = re.compile(r'\\[a-zA-Z]+')

with open('report.md', 'r', encoding='utf-8') as file:
    for line_number, line in enumerate(file, start=1):
        if any(ord(char) > 127 for char in line):
            print(f"Line {line_number}: {line.strip()}")
        elif re.search(latex_commands, line):
            print(f"Line {line_number}: {line.strip()} (LaTeX command detected)")
