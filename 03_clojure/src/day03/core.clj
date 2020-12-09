(ns day03.core
  (:gen-class))

(defrecord Map [width height rows])

(defn get-cell [m nrow ncol]
  (let [row (nth (:rows m) nrow)] 
    (nth row (mod ncol (count row)))))
  
(defn tree? [m nrow ncol]
  (zero? (compare \# (get-cell m nrow ncol))))

(defn read-map [f]
  (let [rows (vec (line-seq f))
        width (count (first rows))
        height (count rows)]
    (Map. width height rows)))

(defn count-trees [m right down]  
  (loop [row 0 
         col 0 
         result 0]    
    (if (> row (- (:height m) 1)) 
      result
      (let [updated (if (tree? m row col) (inc result) result)]
        (recur (+ down row) (+ right col) updated)))))

(defn solve-1 [m] 
  (count-trees m 3 1))

(defn solve-2 [m]
  (let [trajectories [[1 1] [3 1] [5 1] [7 1] [1 2]]]
    (apply * (map #(apply count-trees m %1) trajectories))))

(defn -main
  [& args]
    (with-open [r (java.io.BufferedReader. *in*)]
      (let [m (read-map r)] 
        (println (solve-1 m) (solve-2 m)))))
