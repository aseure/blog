---
title: "Accepts or discards all changes on Git conflicts"
date:  "2020-09-01"
---

Once you start dealing with conflicts in Git, one question often comes back:

> How to accept/discard all changes from the other/base branch?

And, as always in tech, the answer is: _it depends_. It depends on whether
you are merging from another branch, or rebasing on a base branch. Here's why.

## Conflicts when merging

When you are merging a branch, say `feat`, into the base branch on which
you are currently working, say `master`, the command you would use is `git
merge feat`. By doing so, git will produce a new commit on `master`. This
commit will in effect be the top of the `master` branch, leaving the `feat`
branch where it was. This may sound trivial but it has some importance.

Now, let's imagine that your `feat` branch is conflicting with your base
branch, and you would like to retain all the changes from `feat` no matter
what. In that case, you can tell git to automatically deal with conflicts by
accepting all `feat` changes with a `git merge -X theirs feat`. The extra
_strategy option_ (`-X`/`--strategy-option`) we passed here indicates that
all conflicts must be resolved by preferring the changes from the branch we
are bringing in, in other words, _their_ changes.

This should come to no surprise but you can get the opposite behaviour by
preferring the changes from the base branch using the `-X ours` strategy
option. In that case, because the changes of the currently checked out
branch are preferred, those are considered as _our_ changes, as opposed to
the changes from the branch we are bringing in.

As always, don't hesitate to refer to the official man page of the
merge command using `man git-merge` which is well detailed and is
completely offline. The equivalent online documentation is [available
here](https://git-scm.com/docs/git-merge).

Does it all make sense now? `ours` refers to the base branch while `theirs`
corresponds to the other branch. Well, during a rebase, this is the
opposite. Git's fun, right?

## Conflicts when rebasing

In case you're wondering: no, git authors are not mad men who just want their
users to suffer every time they use `rebase`. The real reason is consistency.

Let's perform a rebase from our previous example using the `git rebase master`
command (supposing we started from the `feat` branch) to understand why
`ours` and `theirs` work oppositely.

When conflicts arise during a rebase, you would have to specify `-X theirs` to
force git to resolve conflicts by applying `feat` branch changes. Conversely,
if your goal is to resolve the conflicts by always using the changes from
the base branch, you would need to use `-X ours`.

This surely sounds counter-intuitive at first. However, if we take the time
to put ourselves in the shoes of `git rebase`, this makes more sense.

Here's what is (mostly) happening during our `git rebase master` operation:

```sh
# Step 1.
git checkout <HASH_OF_THE_COMMIT_POINTED_BY_THE_MASTER_BRANCH>

# Step 2.
git cherry-pick <FIRST_COMMIT_OF_FEAT_BRANCH>
git cherry-pick <SECOND_COMMIT_OF_FEAT_BRANCH>
# ... a few more cherry-picks may happen here

# Step 3.
git branch --force feat HEAD
```

You can notice from steps 1. and 3. that the rebase does not operate directly
onto the `feat` branch. Instead, it cherry-picks the commits from the `feat`
branch, one by one (this is step 2), directly onto the original commit
pointed by the `master` branch.

In that context, we can see why the changes of the `feat` branch, from which
we started the rebase, are considered as `theirs`. Meanwhile, the commits
from the base branch `master` are considered as `ours`. What happens here is
the same as what we described in the previous section. The difficulty only
lies in the fact that rebase moves around while doing its duties, and does
not remain on the branch it started from.

