# AWS EKS managed add-on policies

Standalone OPA/Rego policy bundle for EKS managed add-on evidence emitted by the `plugin-aws-eks` collector.

## Input schema

Each policy evaluates one EKS managed add-on at a time using:

- `input.addon`
- `input.addon_context`

Current add-on context includes add-on status, EKS health issue count, cluster name, add-on version, owner, publisher, tag presence, service account role presence, and parent cluster reference.

## Current coverage

This bundle currently checks managed add-on posture:

- add-on is active and has no unresolved EKS health issues

Cluster-level required add-on presence is handled by `plugin-aws-eks-policies` because that evidence is scoped to the EKS cluster.

## Policy data

Default baselines live in `policies/data.json` and can be overridden by agent-supplied policy data. Current settings cover approved add-on statuses.

## Testing

Run local checks with:

```shell
opa check policies
opa test policies
```

Or use the Makefile wrappers:

```shell
make validate
make test
```

## Bundling

Build the distributable bundle with:

```shell
make build
```

This writes `dist/bundle.tar.gz`.
