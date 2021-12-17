variable "name" {
  description = "Cluster name"
  type        = string
}

variable "description" {
  description = "Cluster description"
  type        = string
}

variable "flux_git_repo" {
  description = "GitRepository URL"
  type        = string
  default     = ""
}

variable "cronitor_api_key" {
  description = "Cronitor API key. Leave empty to destroy"
  type        = string
  default     = ""
}

variable "cronitor_pagerduty_key" {
  description = "Cronitor PagerDuty key"
  type        = string
  default     = ""
}

variable "api_endpoint" {
  description = "Kubernetes API endpoint (Informative only)"
  type        = string
  default     = ""
}

variable "manifests_path" {
  description = "Manifests dir inside GitRepository"
  type        = string
  default     = ""
}

variable "manifests_template_vars" {
  description = "Template vars for use by cluster manifests"
  type        = any
  default = {
    alertmanager_pagerduty_key : ""
  }
}

variable "kubeconfig_filename" {
  description = "Kubeconfig path"
  type        = string
  default     = "~/.kube/config"
}

variable "get_kubeconfig_command" {
  description = "Command to create/update kubeconfig"
  type        = string
  default     = "true"
}

variable "flux_wait" {
  description = "Wait for all manifests to apply"
  type        = bool
  default     = true
}

variable "customer_name" {
  description = "Customer name (Informative only)"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zones" {
  description = "GCP Zones"
  type        = list(string)
}

variable "node_pools" {
  description = "List of maps containing node pools"
  type        = list(map(string))
  default = [ 
    { 
      "name": "default-node-pool" 
    } 
  ]
}

variable "maintenance_exclusions" {
  description = "Description: List of maintenance exclusions. A cluster can have up to three"
  type        = list(object({ 
    name = string, 
    start_time = string, 
    end_time = string 
  }))
  default = []
}

variable "maintenance_start_time" {
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  type        = string
  default     = ""
}

variable "configure_ip_masq" {
  description = <<-EOF
    Enables the installation of ip masquerading, 
    which is usually no longer required when using aliasied IP addresses. 
    IP masquerading uses a kubectl call, so when you have a private cluster, 
    you will need access to the APIs
  EOF
  type        = bool
  default     = false
}

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  type        = number
  default     = 110
}

variable "kubernetes_version" {
  description = <<-EOF
    The version of Kubernetes to install 
    Options: https://cloud.google.com/kubernetes-engine/docs/release-notes#current_versions
    Example: 1.20.11-gke.1300
  EOF
  type        = string
  default     = "latest"
}

variable "release_channel" {
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`."
  type        = string
  default     = "STABLE"
}

variable "remove_default_node_pool" {
  description = "Remove the default node pool"
  type        = bool
  default     = false
}

variable "initial_node_count" {
  description = "The number of nodes to create in this cluster's default node pool."
  type        = number
  default     = 1
}

variable "cluster_autoscaling" {
  description = "Cluster autoscaling configuration"
  type = object({ 
    enabled = bool,
    min_cpu_cores = number, 
    max_cpu_cores = number,
    min_memory_gb = number,
    max_memory_gb = number,
    gpu_resources = list(object({ 
      resource_type = string, 
      minimum = number, 
      maximum = number 
    }))
  })
  default = { 
    "enabled": false, 
    "gpu_resources": [], 
    "max_cpu_cores": 0, 
    "max_memory_gb": 0, 
    "min_cpu_cores": 0, 
    "min_memory_gb": 0 
  }
}

variable "grant_registry_access" {
  description = "Grants created cluster-specific service account storage.objectViewer and artifactregistry.reader roles."
  type = bool
  default = false
}

variable "network" {
  description = "The VPC network to host the cluster in (required)"
  type = string
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in (required)"
  type = string
}

variable "ip_range_pods" {
  description = "The name of the secondary subnet ip range to use for pods"
  type = string
  default = ""
}

variable "ip_range_services" {
  description = "	The name of the secondary subnet range to use for services"
  type = string
  default = ""
}

variable "http_load_balancing" {
  description = "Whether http load balancing enabled"
  type = bool
  default = false
}

variable "horizontal_pod_autoscaling" {
  description = "Whether horizontal pod autoscaling enabled"
  type = bool
  default = true
}

variable "network_policy" {
  description = "Whether network policy enabled"
  type = bool
  default = false
}

variable "node_pools_oauth_scopes" {
  description = "Map of lists containing node oauth scopes by node-pool name"
  type = map(list(string))
  default = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]    
  }
}

variable "node_pools_labels" {
  description = "Map of maps containing node labels by node-pool name"
  type = map(map(string))
  default = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }    
  }
}

variable "node_pools_metadata" {
  description = "Map of maps containing node metadata by node-pool name"
  type = map(map(string))
  default = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }    
  }
}

variable "node_pools_taints" {
  description = "Map of lists containing node taints by node-pool name"
  type = map(list(object({ key = string, value = string, effect = string })))
  default = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]    
  }
}

variable "node_pools_tags" {
  description = "Map of lists containing node network tags by node-pool name"
  type = map(list(string))	
  default = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }    
}

variable "network_project_id" {
  description = "The project id of the network"
  type = string
  default = ""
}

variable "enable_private_endpoint" {
  description  = "(Beta) Whether the master's internal IP address is used as the cluster endpoint"
  default      = false
}

variable "enable_private_nodes" {
  description  = "(Beta) Whether nodes have internal IP addresses only"
  default      = false
}
