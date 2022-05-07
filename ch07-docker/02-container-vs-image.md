# Containers vs. Images

## What is a Container?

A **container** is a layer of **images**. Mostly linux-based images ("alpine"), because smaller in size. The application image (e.g. Postgres) is on top of the the layer. It is a **running instance** of an image.

An **image** is the **artifact** with all the packaged dependencies that can be moved around.