(defun ormail/hello ()
  (interactive)
  (notmuch-hello))

(defun ormail/search ()
  (interactive)
  (notmuch-search :sort-order newes-first))

(defun ormail/tree ()
  (interactive)
  (notmuch-tree))

(defun ormail/jump-search ()
  (interactive)
  (notmuch-jump-search)
  (bind-map-change-major-mode-after-body-hook))

(defun ormail/new-mail ()
  (interactive)
  (notmuch-mua-new-mail))

(defun ormail/inbox-and-unread ()
  (interactive)
  (notmuch-tree "tag:inbox or tag:unread")
  (bind-map-change-major-mode-after-body-hook))

(defun ormail/unread ()
  (interactive)
  (notmuch-tree "tag:unread")
  (bind-map-change-major-mode-after-body-hook))

(defun ormail/tree-show-message ()
  (interactive)
  (notmuch-tree-show-message-in)
  (select-window notmuch-tree-message-window))

(defun ormail/search-show-message ()
  (interactive)
  (notmuch-search-show-thread)
  (select-window notmuch-tree-message-window))

(defun notmuch-tree-mark-message-unread-then-next (&optional unread)
  "Mark the current message as unread and move to next matching message."
  (interactive "P")
  (notmuch-tree-mark-message-read t)
  (notmuch-tree-next-matching-message))

(defun notmuch-tree-mark-message-read-then-next (&optional unread)
  "Mark the current message as read and move to next matching message."
  (interactive "P")
  (notmuch-tree-mark-message-read nil)
  (notmuch-tree-next-matching-message))

(defun notmuch-tree-mark-message-read (&optional unread)
  (interactive "P")
  (notmuch-tree-tag (notmuch-tag-change-list '("-unread") unread)))

(defun notmuch-tree-mark-message-spam-then-next (&optional unread)
  (interactive "P")
  (notmuch-tree-tag (notmuch-tag-change-list '("+spam" "-inbox" "-unread") unread))
  (notmuch-tree-next-matching-message))

(defun notmuch-tree-mark-message-inbox-then-next (&optional unread)
  (interactive "P")
  (notmuch-tree-tag (notmuch-tag-change-list '("+inbox") unread))
  (notmuch-tree-next-matching-message))

(defun notmuch-tree-unarchive-thread (&optional unarchive)
  (interactive "P")
  (when notmuch-archive-tags
    (notmuch-tree-tag-thread
     (notmuch-tag-change-list notmuch-archive-tags t))))

(eval-after-load "notmuch"
  '(defun notmuch-show-insert-part-text/calendar (msg part content-type nth depth button)
     (notmuch-show-insert-part-*/* msg part content-type nth depth button)))

(defun notmuch-tree-archive-thread-and-next-message (&optional unarchive)
  "Archive each message in thread. And go to next matching message"
  (interactive "P")
  (notmuch-tree-archive-thread)
  (notmuch-tree-next-thread)
  (while (and (not (eobp)) (not (notmuch-tree-get-match)))
    (forward-line))
  (when (window-live-p notmuch-tree-message-window)
    (notmuch-tree-show-message-in)))
