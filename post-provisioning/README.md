## Post-provisioning actions

This module is probably an anti-pattern and a result of probably too ambitious usage of `depends_on`.
In any case, the Prometheus stack needs to be restarted so that Linkerd can inject the sidecars after the Prometheus namespace is annotated. It seems that the obvious solution - provisioning Linkerd first and Prometheus second - doesn't quite work, since Linkerd cannot "catch" it (on time).

This module should always be executed last.

This module is a candidate for refactoring.
