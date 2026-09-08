# Branch protection

Protect the default branch with the following pull-request status check:

- **`devenv / Linux` — required.** This is the stable Linux job in
  `workflows/devenv.yml`. The workflow deliberately runs the aggregate
  `ci:all` suite as part of `devenv test` on every pull request without path
  filters, so ordinary repository changes—including changes to task
  definitions—cannot bypass validation. Using `devenv test` also checks that the
  development shell can be entered after repository QA passes.

The **`devenv / macOS (advisory)`** job is not a branch-protection requirement.
It runs the same shell test and aggregate suite and reports a real failure when
macOS validation fails; “advisory” must not be implemented with
`continue-on-error`, which would hide that signal. macOS remains non-blocking
because this repository does not yet have enough recorded runner-availability
and runtime data to justify making the less readily available macOS runner part
of the merge gate. Review Actions queue time, execution time, and failure rate
after enough runs have accumulated, and make it required only if those
measurements support doing so.

Do not add pull-request path filtering merely as a convenience. If measured CI
cost eventually justifies filters, maintain a complete dependency list (at a
minimum `Makefile`, `bin/**`, `scripts/**`, `stow/**`, `docs/**`, `flipper/**`,
`.claude/**`, `.github/**`, `requirements.txt`, and every devenv file), ensure
task-definition changes trigger all affected tasks, and add a scheduled,
unfiltered full run. Because skipped workflows can leave required checks
pending, preserve an always-created required Linux check when implementing any
such optimization.
