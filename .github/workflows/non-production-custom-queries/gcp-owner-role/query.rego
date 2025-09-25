package Cx
import data.generic.common as common_lib

# Policy to flag any assignment of roles/owner in Terraform, including within modules
CxPolicy[result] {
    module := input.document[i].module[name]

    # Ensure 'roles' is defined in the resource/module and iterate over each role
    roles := module.roles
    role := roles[_]

    # Check if 'roles/owner' is assigned to any member in the roles list
    contains(role, "roles/owner")

    # Define the result if the condition is met
    result := {
        "documentId": input.document[i].id,
        "resourceType": "module",                                   # Sets resource type as 'module' (generalized)
        "resourceName": input.document[i].id,                       # Use the resource/module ID as the name
        "searchKey": sprintf("%s.roles", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Please use the most restrictive predefined role that meets your use case requirements.",
        "keyActualValue": sprintf("roles includes %s", [role]),
        "searchLine": common_lib.build_search_line(["module", name, "roles"], []),
    }
}
