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
find . | grep -E ./.?.txt | xargs -p rm
rm ./e.txt ./d.txt ./a.txt ./c.txt ./b.txt?...
```

5. 

```Shell
$ touch foo bar "foo bar"
ls
 foo   bar   'foo bar'
find . | grep foo | xargs -p rm
$ rm ./foo bar ./foo?...
$ find . | grep foo | xargs rm
rm: cannot remove './foo': No such file or directory
ls
 'foo bar'
```
