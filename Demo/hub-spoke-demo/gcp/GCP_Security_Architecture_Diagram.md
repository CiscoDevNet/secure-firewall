# GCP Multi-VPC Security Architecture Diagram

## Network Architecture Overview

```
                                    ┌─────────────────────────────────────────────────────────────┐
                                    │                        INTERNET                             │
                                    └─────────────────────────┬───────────────────────────────────┘
                                                              │
                                    ┌─────────────────────────▼───────────────────────────────────┐
                                    │                OUTSIDE VPC                                  │
                                    │                (10.0.2.0/24)                               │
                                    │                                                             │
                                    │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
                                    │  │   EGRESS     │  │   INGRESS    │  │  EAST-WEST   │     │
                                    │  │   FTDv       │  │   FTDv       │  │   FTDv       │     │
                                    │  │ .10 (nic0)   │  │ .20 (nic0)   │  │ .30 (nic0)   │     │
                                    │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
                                    └─────────┼──────────────────┼──────────────────┼─────────────┘
                                              │                  │                  │
                                    ┌─────────▼──────────────────▼──────────────────▼─────────────┐
                                    │                 INSIDE VPC (Security Hub)                   │
                                    │                   (10.0.3.0/24)                            │
                                    │                                                             │
                                    │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
                                    │  │   EGRESS     │  │   INGRESS    │  │  EAST-WEST   │     │
                                    │  │   FTDv       │  │   FTDv       │  │   FTDv       │     │
                                    │  │ .10 (nic1)   │  │ .20 (nic1)   │  │ .30 (nic1)   │     │
                                    │  └──────────────┘  └──────────────┘  └──────────────┘     │
                                    └─────────┬─────────────────────────────────────┬─────────────┘
                                              │                                     │
                        ┌─────────────────────┴─────────────┐       ┌──────────────┴─────────────────┐
                        │         VPC PEERING               │       │         VPC PEERING            │
                        │    (Bidirectional)                │       │    (Bidirectional)             │
                        │                                   │       │                                │
                        ▼                                   ▼       ▼                                ▼
        ┌───────────────────────────────────┐                       ┌───────────────────────────────────┐
        │           SPOKE1 VPC              │                       │           SPOKE2 VPC              │
        │         (172.0.0.0/16)            │                       │         (192.0.0.0/16)            │
        │                                   │                       │                                   │
        │  ┌─────────────────────────────┐  │                       │  ┌─────────────────────────────┐  │
        │  │    Private Subnet           │  │                       │  │    Private Subnet           │  │
        │  │    (172.0.0.0/24)           │  │                       │  │    (192.0.0.0/24)           │  │
        │  │                             │  │                       │  │                             │  │
        │  │  ┌─────────────────────┐    │  │                       │  │  ┌─────────────────────┐    │  │
        │  │  │    Debian VM        │    │  │                       │  │  │    Debian VM        │    │  │
        │  │  │   (Test Workload)   │    │  │                       │  │  │   (Test Workload)   │    │  │
        │  │  └─────────────────────┘    │  │                       │  │  └─────────────────────┘    │  │
        │  └─────────────────────────────┘  │                       │  └─────────────────────────────┘  │
        └───────────────────────────────────┘                       └───────────────────────────────────┘

        ┌───────────────────────────────────┐                       ┌───────────────────────────────────┐
        │        MANAGEMENT VPC             │                       │        DIAGNOSTIC VPC             │
        │        (10.0.0.0/24)              │                       │        (10.0.1.0/24)              │
        │                                   │                       │                                   │
        │  ┌──────────────┐  ┌──────────────┐│  ┌──────────────┐    │  ┌──────────────┐  ┌──────────────┐│  ┌──────────────┐
        │  │   EGRESS     │  │   INGRESS    ││  │  EAST-WEST   │    │  │   EGRESS     │  │   INGRESS    ││  │  EAST-WEST   │
        │  │   FTDv       │  │   FTDv       ││  │   FTDv       │    │  │   FTDv       │  │   FTDv       ││  │   FTDv       │
        │  │ .10 (nic2)   │  │ .20 (nic2)   ││  │ .30 (nic2)   │    │  │ .10 (nic3)   │  │ .20 (nic3)   ││  │ .30 (nic3)   │
        │  └──────────────┘  └──────────────┘│  └──────────────┘    │  └──────────────┘  └──────────────┘│  └──────────────┘
        └───────────────────────────────────┘                       └───────────────────────────────────┘
```

## VPC Peering Details

### The 4 VPC Peering Connections:

```
                            INSIDE VPC (Security Hub)
                                 (10.0.3.0/24)
                                      │
                    ┌─────────────────┼─────────────────┐
                    │                 │                 │
                    ▼                 │                 ▼
        ┌─────────────────┐          │          ┌─────────────────┐
        │   SPOKE1 VPC    │          │          │   SPOKE2 VPC    │
        │ (172.0.0.0/16)  │          │          │ (192.0.0.0/16)  │
        └─────────────────┘          │          └─────────────────┘
                                     │
        
        Peering Connections:
        1. spoke1_to_inside    ←────┐│
        2. inside_to_spoke1    ─────┘│
        3. spoke2_to_inside    ←─────┘
        4. inside_to_spoke2    ──────┐
```

### Bidirectional Communication:

```
SPOKE1 VPC  ⟷  INSIDE VPC  ⟷  SPOKE2 VPC
   │              │              │
   │              │              │
   └──── No Direct Connection ───┘
        (Traffic must go through 
         Inside VPC firewalls)
```

## Traffic Flow Examples

### 1. Spoke1 → Internet (Egress Traffic)
```
Spoke1 VM → Spoke1 VPC → (VPC Peering) → Inside VPC → Egress FTDv → Outside VPC → Internet
```

### 2. Internet → Spoke1 (Ingress Traffic)
```
Internet → Outside VPC → Ingress FTDv → Inside VPC → (VPC Peering) → Spoke1 VPC → Spoke1 VM
```

### 3. Spoke1 → Spoke2 (East-West Traffic)
```
Spoke1 VM → Spoke1 VPC → (VPC Peering) → Inside VPC → East-West FTDv → Inside VPC → (VPC Peering) → Spoke2 VPC → Spoke2 VM
```

## FTDv Interface Mapping

Each FTDv has 4 network interfaces in different VPCs:

| Interface | VPC           | CIDR          | Purpose           | IP Examples |
|-----------|---------------|---------------|-------------------|-------------|
| nic0      | Outside VPC   | 10.0.2.0/24   | External/Internet | .10, .20, .30 |
| nic1      | Inside VPC    | 10.0.3.0/24   | Internal/Security | .10, .20, .30 |
| nic2      | Management    | 10.0.0.0/24   | Management Access | .10, .20, .30 |
| nic3      | Diagnostic    | 10.0.1.0/24   | Diagnostics/Logs  | .10, .20, .30 |

## Security Benefits

1. **Centralized Security**: All traffic flows through FTDv firewalls in Inside VPC
2. **Segmentation**: Spokes cannot communicate directly - must go through East-West firewall
3. **Internet Control**: All internet traffic filtered through Egress/Ingress firewalls
4. **Management Isolation**: Separate management network for FTDv administration
5. **Monitoring**: Dedicated diagnostic network for logging and monitoring

## Machine Types
- **FTDv Firewalls**: `c2-standard-8` (8 vCPUs, 32GB RAM)
- **Spoke VMs**: `e2-medium` (2 vCPUs, 4GB RAM)