# METADATA
# title: EKS managed add-on should be active and healthy
# description: An EKS managed add-on that is not ACTIVE or has unresolved health issues may degrade critical cluster capabilities such as networking, DNS, or observability.
# custom:
#   controls:
#     - A1.2
#     - CC7.2
#   schedule: "0 */6 * * *"

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

risk_templates := [
	{
		"name":            "EKS managed add-on is not active",
		"title":           "EKS managed add-on is not in ACTIVE state",
		"statement":       "The add-on is not in an active state, which may cause cluster networking, DNS, or other critical functions to degrade depending on the add-on's role.",
		"likelihood_hint": "medium",
		"impact_hint":     "high",
		"violation_ids":   ["eks_addon_not_active"],
		"remediation": {
			"title":       "Investigate and remediate the add-on status",
			"description": "Review EKS add-on health events and re-deploy or update the add-on to return it to ACTIVE state.",
			"tasks": [
				{"title": "Check add-on health events in the EKS console or via AWS CLI"},
				{"title": "Update the add-on to the latest compatible version if a version issue is reported"},
				{"title": "Verify the add-on reaches ACTIVE status after remediation"}
			]
		}
	},
	{
		"name":            "EKS managed add-on has health issues",
		"title":           "EKS managed add-on has unresolved health issues reported by AWS",
		"statement":       "AWS has reported one or more unresolved health issues for this add-on that may affect cluster stability or the functionality provided by the add-on.",
		"likelihood_hint": "medium",
		"impact_hint":     "medium",
		"violation_ids":   ["eks_addon_health_issues_present"],
		"remediation": {
			"title":       "Resolve add-on health issues",
			"description": "Review and address the reported health issues for the add-on.",
			"tasks": [
				{"title": "Review add-on health issues via the EKS console or AWS CLI"},
				{"title": "Address the root cause of each reported health issue"},
				{"title": "Verify health issue count returns to zero after remediation"}
			]
		}
	},
]
