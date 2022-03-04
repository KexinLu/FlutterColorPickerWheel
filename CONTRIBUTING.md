# Contributing to FlutterWheelColorPicker

Thank you for your interest in this project and contributing to it. Let's group the flutter ecosystem 
together.

The following is a set of guidelines for contributing to FlutterWheelColorPicker.

These are guidelines but not rules, feel free to propose changes if you'd like to change the guideline.

## Found a bug?

When you find a bug, please first check out the issue list to see if there's already a bug report in there.
If not, describe the bug, with screenshots and code that you used. Once we confirm the nature of the bug, we will
triage the bug and put it into the pipeline

## Proposing a Change

When you have some great idea that you want to put into this project, please file an issue first, so we can discuss
and come to an agreement, especially if the api is changing in your proposal. We strongly encourage you to do this 
before committing too much effort into making the change.

## Creating a Pull Request

Before creating a pull request please:

1. Fork the repository and create your branch from `main`.
2. Install all dependencies (`flutter packages get` or `pub get`).
3. Squash your commits and ensure you have a meaningful commit message.
4. If you’ve fixed a bug or added code that should be tested, add tests!
   Pull Requests without 100% test coverage will not be approved.
5. Ensure the test suite passes.
6. If you've changed the public API, make sure to update/add documentation.
7. Format your code (`dartfmt -w .`).
8. Analyze your code (`dartanalyzer --fatal-infos --fatal-warnings .`).
9. Create the Pull Request.
10. Verify that all status checks are passing.

While the prerequisites above must be satisfied prior to having your
pull request reviewed, the reviewer(s) may ask you to complete additional
design work, tests, or other changes before your pull request can be ultimately
accepted.

## Contributing to Storybook

Storybook is in the example folder

1. Fork the repository and create your branch from `main`.
2. Install all dependencies (`flutter packages get` or `pub get`).
3. Squash your commits and ensure you have a meaningful commit message.
4. Format your code (`dartfmt -w .`).
5. Analyze your code (`dartanalyzer --fatal-infos --fatal-warnings .`).
6. Run the storybook and make sure you haven't broken any existing stories.
7. Create the Pull Request.
Note: having less or no tests in storybook is acceptable.

If you want to help maintain translations in the future, add yourself to `.github/DOCS_ISSUE_TEMPLATE.md`.

## Getting in Touch

If you want to just ask a question or get feedback on an idea you can post it
on [Slack](https://join.slack.com/t/techporplabopensource/shared_invite/zt-14v6ywarl-auSu4GZ1PZ1YgP4GzH6MDw)

## License
By contributing to FlutterWheelColorPicker, you agree that your contributions will be licensed
under its [MIT license](LICENSE).