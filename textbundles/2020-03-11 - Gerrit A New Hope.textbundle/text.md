# Gerrit: A New Hope?
After having worked with [Gerrit](https://www.gerritcodereview.com/) a long time ago, I took a day last week to experiment with it (more specifically, [GerritHub](http://gerrithub.io/)) to see how things changed since then and how easy or hard it was to set up and sync with Github. Long story short, the time hasn't come yet for Gerrit to replace Github as the primary code review tool for developers.

When doing my end-of-study internship at Arista back in 2015, I had the opportunity to work with Gerrit. Even though I worked a bit with Github before, Gerrit was the first code review tool I used in a professional context. By the end of my internship, I was sold: even though the UI was complicated, I liked Gerrit and the trunk-based model it enforces. Sadly since then, I've never used it again. At Algolia, all our repositories are hosted and reviewed through Github. So last week, I took a day to give a try to Gerrit through GerritHub, which promises to sync easily with Github and let developers review their code within Gerrit.

The setup process is quite simple: once logged in with your Github account, Gerrit offers to sync — i.e. clone — your Github repositories with Gerrit. And here comes the first drawback: to be able to work with Gerrit, you'll need to re-clone all your repositories, to make all the `git fetch` and `git push` commands target the Gerrit repository instead of the Github one. At least, once done, Gerrit provides the appropriate git clone command to do so, with some extra niceties.

```sh
git clone “ssh://aseure@review.gerrithub.io:29418/aseure/algoliasearch-client-go” && \
scp -p -P 29418 aseure@review.gerrithub.io:hooks/commit-msg “algoliasearch-client-go/.git/hooks/“
```

Wow! It looks rather complex.

As we can see, the command is split into two parts: first, a `git clone` followed by an `scp` of a file from the Gerrit repository into my cloned repository's hooks directory. This `commit-msg` hook is the most original part of Gerrit, but let's keep that for another post.

Now, the rest of the process is similar to Github: create a branch, commit, push to the remote. Well, yes, everything is the same but let's take a look at the push command:

```sh
git push origin HEAD:refs/for/master
```

If you are not familiar with the push syntax, here comes the verbose explanation. It tells git to push any commits from `HEAD` (current commit, i.e., the most recent one on your branch) to the branch `refs/for/master`, which belongs to the distant remote repository named `origin`. Without getting into too many details — `refs/for/master` is not even a branch — the goal is to send commits on top of a distant branch. So here's the second drawback for most developers: you don't push branches anymore, only commits on top of other distant branches. The reason is that Gerrit reviews are commit-based, so branches aren't really a thing, except for base branches. Sadly, after even a few hours, I was still wrongly pushing with a simple `git push`, which effectively updates the branch on Gerrit side without offering to review the changes…

Lastly, let's talk about Github synchronization. Because most of our repositories are public on Github, we cannot leave the platform, and pull requests from external contributors have to be handled. But again, Gerrit falls short here. For each pull request, one has to manually convert it to Gerrit via the dashboard, so no automatic out-of-the-box sync.

So, is Gerrit ready to replace Github widely for code reviews? I don't think so. May things change? Yes definitely. Of all the downsides I've mentioned, most of them can be fixed more or less easily with appropriate tooling. The question is: will developers care enough to develop those tools to improve their code reviews? I'm not so sure about that. For now, even if I'd really like to see Gerrit gets more traction, we see a trend at Github for improving things quickly since the Microsoft acquisition. In that case, I'd much prefer to stay in Github and wait for those changes to come instead of investing time building soon-to-be-outdated tools. This year, we may see [stacked diffs coming to Github](https://twitter.com/natfriedman/status/1170804894241972224), which would be an excellent addition. However, because of the nature of Github branching and forking models, I don't see *à la* Gerrit revision-based commits coming anytime soon.