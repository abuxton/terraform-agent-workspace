terraform {
  cloud{
    hostname     = "${hostname}"
    organization = "${organization}"

    workspaces {
      name = "${workspace}"
    }

    # Optional: project (some TFE installs use projects to partition workspaces)
    %{ if project != "" }
    project = "${project}"
    %{ endif }

    # Tags are optional and are written as a JSON array in the generated file
    %{ if tags != "" }
    tags = ${tags}
    %{ endif }
  }
}
