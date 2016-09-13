// Get the root URL, including protocol/port
var windowRootUrl = window.location.href.replace(window.location.pathname, '');

window.OzoneConfig = {
    "API_URL": windowRootUrl + "/",
    "HELP_URL": windowRootUrl + "/help/#/",
    "METRICS_URL": "https://localhost:4450/",
    "METRICS_HUD_SITE_ID": 13,
    "METRICS_WEBTOP_SITE_ID": 12,
    "IE_REDIRECT_URL": "https://browser-update.org/update.html",
    "CENTER_URL": windowRootUrl + "/center/",
    "CENTER_REVIEWS_CHAR_LIMIT": 20,
    "HUD_URL": windowRootUrl + "/hud/",
    "WEBTOP_URL": windowRootUrl + "/webtop/",
    "IWC_URL": windowRootUrl + "/iwc/",
    //demo apps expect this format
    "iwcUrl": windowRootUrl + "/iwc/",
    "DEVELOPER_RESOURCES_URL": "#",
    "APP_TITLE": 'AppsMall Center',
    "FEEDBACK_ADDRESS": "mailto:person@address.com",
    "HELPDESK_ADDRESS": "mailto:helpdesk@address.com",
    "REQUEST_ADDRESS": "mailto:request@address.com",
    "SOCIAL_CHIRP_ADDRESS": "http://localhost:8000/dist",
    "SOCIAL_PIN_ADDRESS": "http://localhost:8000/dist",
    "SOCIAL_CHAT_ADDRESS": "http://localhost:8000/dist",
    "SOCIAL_BLOG_ADDRESS": "http://localhost:8000/dist",
    'HELP_DOCS': {
        'Help doc 1': '/path/to/document',
        'Help doc 2': '/path/to/document',
        'Help doc 3': '/path/to/document',
        'Help doc 4': '/path/to/document',
        'Help doc 5': '/path/to/document'
    },
    'HELP_VIDEOS': {
        'Video 1': '/path/to/video',
        'Video 2': '/path/to/video',
        'Video 3': '/path/to/video',
        'Video 4': '/path/to/video',
        'Video 5': '/path/to/video'
    }
};
