# Docker vs. Virtual Machines

## Operating Systems
OSs have two layers: the Kernel and the Application layers.

The **OS Kernel** is the part that communicates with the hardware. **Application** layer runs on top of the Kernel layer.

**Docker** virtualizes the Application layer. It uses the kernel of the HOST, because it doesn't have its own kernel. **VM**s have their own kernel, and virtualize both the application and kernel.

Docker images may not run on hosts with different kernels than the image itself. VMs don't have this issue.