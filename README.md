# Reuman Lab website

Source for <https://reumanlab.org>. Built with [Quarto](https://quarto.org/) and deployed to GitHub Pages via GitHub Actions.

## Local development

```sh
quarto preview    # live-reload preview at http://localhost:port
quarto render     # build static site into _site/
```

## Deployment

Pushes to `main` trigger `.github/workflows/publish.yml`, which renders the site and publishes it to GitHub Pages.
