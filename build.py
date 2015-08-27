import os, json, zipfile

name = None
with open('info.json') as info:
  data = json.load(info)
  name = data['name'] + '_' + data['version']

zipf_name = name + '.zip'
zipf = zipfile.ZipFile(zipf_name, 'w')
wd = os.getcwd()
rootlen = len(wd)
for root, dirs, files in os.walk(wd):
  for file in files:
    path_abs = os.path.join(root, file)
    path_dest = os.path.join(name, os.path.relpath(path_abs))
    if '.git' in path_dest or file.endswith('.zip'):
      continue
    zipf.write(path_abs, path_dest)
zipf.close()

if os.path.isfile('destination.txt'):
  with open('destination.txt') as dest:
    import shutil
    shutil.copy(zipf_name, dest.read())
