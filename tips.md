# AwesomeWM

## Reset retard JAVA apps
```bash
awesome-client 'for _,c in ipairs(client.get()) do
    c.maximized = false;
    c.maximized_horizontal = false;
    c.maximized_vertical = false;
    c.fullscreen = false
    c.floating = false
    c.sticky = false
end'
```