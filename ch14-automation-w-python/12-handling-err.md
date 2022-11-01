# Hanlding Errors

When doing automated tasks, **things can go wrong**. Snapshot creation can fail,
volume attachment can fail, etc. **It's very important to write code that can
handle possible errors.** If errors are not correctly handled, it can lead to
lost/corrupt data, etc.

Terraform takes care of this for us; with Python **we have to do it ourselves**.
Use `try-except` blocks where needed to catch errors and handle them
appropriately.
