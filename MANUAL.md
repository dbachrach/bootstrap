# Manual Setup Steps

These steps can't be automated. Complete them after running `bootstrap.sh`.

---

## 1. Sign into 1Password

Open 1Password and sign into your account. Do this first — other steps may depend on credentials stored there.

---

## 2. Add SSH Key to GitHub

The bootstrap script generates an SSH key and copies it to your clipboard. To connect it to GitHub:

1. Go to [github.com/settings/ssh/new](https://github.com/settings/ssh/new)
2. Set **Title** to something like `MacBook Air — 2026`
3. Set **Key type** to `Authentication Key`
4. Paste your public key into the **Key** field
5. Click **Add SSH key**

To verify it worked:

```sh
ssh -T git@github.com
# Hi dbachrach! You've successfully authenticated...
```

If you need your public key again:

```sh
cat ~/.ssh/id_ed25519.pub | pbcopy
```
