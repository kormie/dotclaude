# Deployment

Safe deployment strategies and procedures for DotClaude configurations.

## Deployment Philosophy

### Safety First Approach
All DotClaude deployments follow these principles:
- **Non-Destructive** - Never overwrite without backup
- **Reversible** - Always provide rollback capability
- **Incremental** - Apply changes gradually
- **Validated** - Test before system-wide deployment

### Deployment Stages
1. **Preparation** - Environment setup and validation
2. **Backup** - Preserve existing configurations
3. **Testing** - Validate in isolated environment
4. **Application** - Deploy configurations safely
5. **Verification** - Confirm successful deployment
6. **Documentation** - Record changes and procedures

## Deployment Methods

### Individual Package Deployment
Deploy specific packages independently:

```bash
# Single package deployment
./scripts/stow-package.sh git

# With explicit testing
./scripts/test-config.sh git
./scripts/stow-package.sh git
./scripts/health-check.sh
```

### Progressive Deployment
Apply packages in logical order:

```bash
# Phase 1: Foundation
./scripts/stow-package.sh environment
./scripts/stow-package.sh aliases

# Phase 2: Core Tools  
./scripts/stow-package.sh git
./scripts/stow-package.sh zsh

# Phase 3: Advanced Features
./scripts/stow-package.sh tmux
./scripts/stow-package.sh neovim
```

### Full System Deployment
Complete DotClaude installation:

```bash
# Automated full deployment
./scripts/deploy-all.sh

# Manual full deployment
for package in environment aliases git zsh tmux neovim; do
    ./scripts/stow-package.sh "$package"
done
```

## Pre-Deployment Checklist

### System Requirements
- [ ] GNU Stow installed
- [ ] Git available
- [ ] Target shell (zsh) installed
- [ ] Required dependencies present

### Environment Validation
- [ ] Backup space available
- [ ] User permissions sufficient
- [ ] No conflicting processes running
- [ ] System stability confirmed

### Configuration Readiness
- [ ] Package integrity verified
- [ ] Dependencies resolved
- [ ] Conflicts identified and planned
- [ ] Rollback procedures tested

## Deployment Procedures

### Standard Deployment Process
1. **Pre-flight Check**
   ```bash
   ./scripts/health-check.sh --pre-deploy
   ```

2. **Create Backup**
   ```bash
   ./scripts/backup.sh
   ```

3. **Test Configuration**
   ```bash
   ./scripts/test-config.sh <package>
   ```

4. **Deploy Package**
   ```bash
   ./scripts/stow-package.sh <package>
   ```

5. **Verify Deployment**
   ```bash
   ./scripts/health-check.sh --post-deploy
   ```

### Emergency Deployment
For urgent fixes or critical updates:

```bash
# Quick deployment with minimal testing
./scripts/backup.sh
./scripts/stow-package.sh <package> --force
./scripts/health-check.sh --quick
```

## Environment-Specific Deployments

### Development Environment
- Full feature set enabled
- Debug logging active
- Extensive testing
- Regular backup cycles

```bash
export DOTCLAUDE_ENV=development
./scripts/deploy-all.sh --dev-mode
```

### Production Environment
- Stable configurations only
- Minimal logging
- Conservative feature set
- Automated backup scheduling

```bash
export DOTCLAUDE_ENV=production
./scripts/deploy-all.sh --production
```

### Testing Environment
- Isolated deployment
- Experimental features
- Comprehensive logging
- Easy rollback

```bash
export DOTCLAUDE_ENV=testing
./scripts/deploy-all.sh --test-mode
```

## Deployment Strategies

### Blue-Green Deployment
Maintain two complete environments:

```bash
# Deploy to green environment
./scripts/deploy-to-env.sh green

# Test green environment
./scripts/test-env.sh green

# Switch to green environment
./scripts/switch-env.sh green

# Remove blue environment
./scripts/cleanup-env.sh blue
```

### Rolling Deployment
Apply changes gradually across packages:

```bash
# Deploy packages one at a time
for package in "${packages[@]}"; do
    ./scripts/deploy-package.sh "$package"
    ./scripts/verify-package.sh "$package"
    sleep 5  # Allow stabilization
done
```

### Canary Deployment
Test with subset of functionality:

```bash
# Deploy to limited scope
./scripts/deploy-canary.sh --packages="git,aliases"

# Monitor and validate
./scripts/monitor-canary.sh

# Full deployment if successful
./scripts/promote-canary.sh
```

## Deployment Automation

### Continuous Deployment
Automated deployment pipeline:

```yaml
# .github/workflows/deploy.yml
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy DotClaude
        run: ./scripts/ci-deploy.sh
```

### Scheduled Deployments
Regular configuration updates:

```bash
# Crontab entry for weekly updates
0 2 * * 0 cd ~/dotfiles && ./scripts/update-all.sh
```

## Post-Deployment Tasks

### Verification Procedures
1. **Functionality Testing** - Verify all features work
2. **Performance Monitoring** - Check system performance
3. **Integration Testing** - Ensure cross-package compatibility
4. **User Acceptance** - Confirm user satisfaction

### Documentation Updates
- Update deployment logs
- Record configuration changes
- Document any issues encountered
- Update user documentation

### Monitoring Setup
- Configure health monitoring
- Set up performance alerts
- Enable error tracking
- Schedule regular checks

## Rollback Procedures

### Automatic Rollback
System detects issues and reverts:

```bash
# Health check triggers rollback
./scripts/health-check.sh --auto-rollback
```

### Manual Rollback
User-initiated reversion:

```bash
# Rollback specific package
./scripts/restore.sh git 2024-06-18

# Full system rollback
./scripts/restore-all.sh 2024-06-18
```

### Emergency Rollback
Critical system recovery:

```bash
# Emergency restore to last known good
./scripts/emergency-restore.sh

# Nuclear option - restore all from backup
./scripts/restore-everything.sh --emergency
```

## Deployment Troubleshooting

### Common Issues
- **Permission Errors** - Check file permissions and ownership
- **Symlink Conflicts** - Resolve overlapping configurations
- **Dependency Issues** - Ensure all requirements met
- **Configuration Errors** - Validate syntax and settings

### Diagnostic Commands
```bash
# Check deployment status
./scripts/deployment-status.sh

# Validate configuration integrity
./scripts/validate-deployment.sh

# Debug deployment issues
./scripts/debug-deployment.sh --verbose
```

### Recovery Strategies
1. **Partial Rollback** - Revert problematic packages only
2. **Configuration Repair** - Fix issues in place
3. **Clean Deployment** - Remove and redeploy
4. **Emergency Recovery** - Full system restoration

## Best Practices

### Planning
- Always plan deployments during low-activity periods
- Have rollback procedures ready
- Test thoroughly in non-production environments
- Communicate changes to users

### Execution
- Follow documented procedures exactly
- Monitor system during deployment
- Keep detailed logs of all actions
- Verify each step before proceeding

### Post-Deployment
- Conduct thorough testing
- Monitor system performance
- Address any issues promptly
- Update documentation and procedures