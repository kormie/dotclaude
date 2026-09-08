# Branch protection

Protect the default branch with the following pull-request status check:

- **`devenv / Linux` — required.** This is the stable Linux job in
  `workflows/devenv.yml`. The workflow deliberately runs the aggregate
  `devenv tasks run ci:all` suite on every pull request without path filters, so
  ordinary repository changes—including changes to task definitions—cannot
  bypass validation.

The **`devenv / macOS (advisory)`** job is not a required check. It runs the same
aggregate suite and provides useful platform coverage, but GitHub-hosted macOS
runners have lower availability and typically take longer to acquire and run
than Linux runners. Keep it advisory unless repository CI measurements show
that its availability and runtime are reliable enough to gate merges; the job
uses `continue-on-error` so macOS infrastructure or platform-only failures do
not block a pull request.

Do not add pull-request path filtering merely as a convenience. If measured CI
cost eventually justifies filters, maintain a complete dependency list (at a
minimum `Makefile`, `bin/**`, `scripts/**`, `stow/**`, `docs/**`, `flipper/**`,
`.claude/**`, `.github/**`, `requirements.txt`, and every devenv file), ensure
task-definition changes trigger all affected tasks, and add a scheduled,
unfiltered full run. Because skipped workflows can leave required checks
pending, preserve an always-created required Linux check when implementing any
such optimization.
