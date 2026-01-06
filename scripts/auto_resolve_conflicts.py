#!/usr/bin/env python3
"""
Simple conflict resolver: for files containing Git conflict markers, replace each
conflict block with the version after the '=======' marker (the incoming change),
saving a .orig backup.

Use with caution. It skips directories named _site, .git, and node_modules by default.
"""
import os
import sys
import re

ROOT = os.path.dirname(os.path.dirname(__file__))
SKIP_DIRS = {'_site', '.git', 'node_modules', 'gems', 'assets'}

conflict_start = re.compile(r'^<<<<<<< .*$')
conflict_sep = re.compile(r'^=======$')
conflict_end = re.compile(r'^>>>>>>> .*$')

def should_skip(path):
    parts = set(path.split(os.sep))
    return bool(parts & SKIP_DIRS)


def resolve_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    if not any('<<<<<<<' in l for l in lines):
        return False

    out_lines = []
    i = 0
    changed = False
    n = len(lines)
    while i < n:
        if conflict_start.match(lines[i]):
            # find separator
            j = i+1
            while j < n and not conflict_sep.match(lines[j]):
                j += 1
            if j >= n:
                # malformed conflict; abort
                print(f"Malformed conflict in {path}; missing =======")
                return False
            k = j+1
            while k < n and not conflict_end.match(lines[k]):
                k += 1
            if k >= n:
                print(f"Malformed conflict in {path}; missing >>>>>>>")
                return False
            # take the section between j+1 and k (the incoming version)
            incoming = lines[j+1:k]
            out_lines.extend(incoming)
            i = k+1
            changed = True
        else:
            out_lines.append(lines[i])
            i += 1

    # backup
    bak = path + '.orig'
    if not os.path.exists(bak):
        os.rename(path, bak)
    else:
        # if backup exists, overwrite it with latest original
        # but keep a timestamped copy
        import time
        t = int(time.time())
        os.rename(path, f"{bak}.{t}")

    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(out_lines)

    return changed


def main():
    fixed = []
    for dirpath, dirnames, filenames in os.walk(ROOT):
        # skip unwanted dirs
        rel = os.path.relpath(dirpath, ROOT)
        if rel != '.' and should_skip(rel):
            dirnames[:] = []
            continue
        for name in filenames:
            if not name.lower().endswith(('.md', '.markdown', '.txt', '.html')):
                continue
            path = os.path.join(dirpath, name)
            try:
                if resolve_file(path):
                    fixed.append(path)
                    print(f"Fixed: {path}")
            except Exception as e:
                print(f"Error processing {path}: {e}")
    print('\nSummary:')
    print(f"Files fixed: {len(fixed)}")
    for p in fixed:
        print(' -', p)

if __name__ == '__main__':
    main()
