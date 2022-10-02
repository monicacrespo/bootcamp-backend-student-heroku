# Introduction
This repository presents Continuous Delivery (CD) using GitHub Actions following the lesson provided by Bootcamp Backend Lemoncode for the [Module 5 - Cloud - Testing - Auto - Heroku - Deploy](https://github.com/Lemoncode/bootcamp-backend/tree/main/00-stack-documental/05-cloud/02-deploy/08-auto-heroku-deploy).

# CD pipelines - GitHub CD Workflows
GitHub Actions brings continuous integration and continuous deployment (CI/CD) directly to the GitHub flow with templates built by developers for developers. 


## Steps to create this workflow
1. Create a `.github/workflows` directory in your repository on Visual Studio Code.
2. In the .github/workflows directory, create a file named `cd.yml` and add the following YAML contents into the `cd.yml` file:

    ```YAML
    name: Continuos Deployment Workflow

    on:
      push:
        branches:
          - main

    env:
      HEROKU_API_KEY: ${{ secrets.HEROKU_API_KEY }}
      IMAGE_NAME: registry.heroku.com/${{ secrets.HEROKU_APP_NAME }}/web

    jobs:
      cd:
        runs-on: ubuntu-latest
        steps:
          - name: Checkout repository
            uses: actions/checkout@v3
          - name: Login heroku app Docker registry
            run: heroku container:login
          - name: Build docker image
            run: docker build -t ${{ env.IMAGE_NAME }} .
          - name: Deploy docker image
            run: docker push ${{ env.IMAGE_NAME }}
          - name: Release
            run: heroku container:release web -a ${{ secrets.HEROKU_APP_NAME }}
    ```

3. Commit, push:

    ```
    git add .
    git commit -m "Added continuous delivery workflow"
    git push 
    ```
    Committing the workflow file to the main branch in your repository triggers the push event and runs your workflow.

