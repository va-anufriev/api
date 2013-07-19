(in-package :tagit)

(defroute (:post "/api/boards/([0-9a-f-]+)/notes") (req res args)
  (catch-errors (res)
    (alet* ((user-id (user-id req))
            (persona-id (post-var req "persona"))
            (challenge (post-var req "challenge"))
            (board-id (car args))
            (note-data (post-var req "data"))
            (note (if persona-id
                      (with-valid-persona (persona-id challenge)
                        (add-note persona-id board-id note-data))
                      (add-note user-id board-id note-data))))
      (send-json res note))))

(defroute (:put "/api/notes/([0-9a-f-]+)") (req res args)
  (catch-errors (res)
    (alet* ((note-id (car args))
            (user-id (user-id req))
            (persona-id (post-var req "persona"))
            (challenge (post-var req "challenge"))
            (note-data (post-var req "data"))
            (note (if persona-id
                      (with-valid-persona (persona-id challenge)
                        (edit-note persona-id note-id note-data))
                      (edit-note user-id note-id note-data))))
      (send-json res note))))

(defroute (:delete "/api/notes/([0-9a-f-]+)") (req res args)
  (catch-errors (res)
    (alet* ((note-id (car args))
            (user-id (user-id req))
            (persona-id (post-var req "persona"))
            (challenge (post-var req "challenge"))
            (nil (if persona-id
                    (with-valid-persona (persona-id challenge)
                      (delete-note persona-id note-id))
                    (delete-note user-id note-id))))
      (send-json res t))))

