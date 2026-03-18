# command practice
1. 

```Shell
$ echo -e "alpha\nbeta\ngamma" | tee sample.txt
alpha
beta
gamma
```

2. 

```Shell
$ cat sample.txt | tr 'a-z' 'A-Z' | tee $(echo sample | tr 'a-z' 'A-Z').txt
ALPHA
BETA
GAMMA
```

3. 

```Shell
$ cat sample.txt | sed 's/^/ITEM: /' | tee sample_item.txt
ITEM: alpha
ITEM: beta
ITEM: gamma
```

4. 

```Shell
$ touch {a..e}.txt
$ find . | grep -E ./.?.txt | xargs -p rm
rm ./e.txt ./d.txt ./a.txt ./c.txt ./b.txt?...
```

5. 

```Shell
$ touch foo bar "foo bar"
ls
 foo   bar   'foo bar'
$ find . | grep foo | xargs -p rm
rm ./foo bar ./foo?...
$ find . | grep foo | xargs rm
rm: cannot remove './foo': No such file or directory
$ ls
 'foo bar'
```

6. 

```Shell
$ du -h . --max-depth=1
228K    ./.git
248K    .
```

7. 

```Shell
$ df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd       1007G   30G  927G   4% /
```

8. 

```Shell
$ file report.pdf
report.pdf: empty
```

9. 

```Shell
$ stat report.pdf
  File: report.pdf
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 830h/2096d      Inode: 5886        Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/    ruha)   Gid: ( 1000/    ruha)
Access: 2026-03-18 23:28:28.382000058 +0900
Modify: 2026-03-18 23:28:28.382000058 +0900
Change: 2026-03-18 23:28:28.382000058 +0900
 Birth: 2026-03-18 23:28:28.382000058 +0900
```
