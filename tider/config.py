update_period = 1000  # in microseconds
offline_timeout = 300  # in seconds
min_duration = 60  # in seconds
break_symbol = '*'
break_period = 600  # in seconds
work_period = 6600  # in seconds
overwork_period = 300  # in seconds
hide_tray = False
hide_win = False
sqlite_manager = 'sqlite3'


# Update window after creation
def win_hook(win):
    win.move(500, 2)


# Update window text
def text_hook(ctx):

    target = ctx.target if ctx.active else 'OFF'
    label = 'TIME {0.duration.h}:{0.duration.m:02d} {1}'.format(ctx, target)

    #text = '[{} {}]'.format('☭' if ctx.active else '☯', label)
    text = '{} {}'.format('WORK' if ctx.active else 'PAUSE', label)
    color = '#DD6600' if ctx.active else '#00AA00'
    markup = '<span color="{}" font="11">{}</span>'.format(color, text)

    import json
    i3bar = json.dumps({'full_text': text, 'color': color})
    with ctx.open('%s/i3bar.txt' % ctx.conf.conf_dir, mode='w') as f: f.write(i3bar)
    return markup
