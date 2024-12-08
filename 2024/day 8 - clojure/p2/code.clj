(ns code
  (:require [clojure.java.io :as io]))

(def dims 50)
(def nodes (atom {}))
(def antinodes (atom #{}))

(with-open [reader (io/reader "../input.txt")]
    (doseq [[y, line] (map-indexed vector (line-seq reader))]
        (doseq [[x, c] (map-indexed vector line)]
            (when (not= (compare c \.) 0)
                (swap! nodes update c (fn [coords] (conj (or coords []) [x, y])))))))

(doseq [[c, coords] @nodes]
    (doseq [[n1, pos1] (map-indexed vector coords)]
        (swap! antinodes conj pos1)
        (doseq [[n2, pos2] (map-indexed vector (drop (+ n1 1) coords))]
            (let [diff [(- (first pos1) (first pos2)), (- (second pos1) (second pos2))]]
                (loop [new [(+ (first pos1) (first diff)), (+ (second pos1) (second diff))]]
                    (when (and 
                        (and (>= (first new) 0) (< (first new) dims))
                        (and (>= (second new) 0) (< (second new) dims)))
                            (swap! antinodes conj new)
                            (recur [(+ (first new) (first diff)) (+ (second new) (second diff))])))
                (loop [new [(- (first pos2) (first diff)), (- (second pos2) (second diff))]]
                    (when (and 
                        (and (>= (first new) 0) (< (first new) dims))
                        (and (>= (second new) 0) (< (second new) dims)))
                            (swap! antinodes conj new)
                            (recur [(- (first new) (first diff)) (- (second new) (second diff))])))))))

(println (count @antinodes))
