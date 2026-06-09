package compliance_framework.eks_addon_require_active_health

violation[{"id": "eks_addon_not_active"}] if {
	not approved_addon_status
}

violation[{"id": "eks_addon_health_issues_present"}] if {
	health_issue_count > 0
}

approved_addon_status if {
	status := data.approved_addon_statuses[_]
	addon_status == status
}

addon_status := object.get(current, "status", "")

health_issue_count := object.get(current, "health_issue_count", 0)

current := object.get(object.get(input, "addon_context", {}), "current", {})

title := "EKS managed add-on should be active and healthy"
description := "EKS managed add-on status should be ACTIVE and EKS should report no unresolved add-on health issues."
