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
        (doseq [[n2, pos2] (map-indexed vector (drop (+ n1 1) coords))]
            (let [
                diff [(- (first pos1) (first pos2)), (- (second pos1) (second pos2))]
                new1 [(+ (first pos1) (first diff)), (+ (second pos1) (second diff))]
                new2 [(- (first pos2) (first diff)), (- (second pos2) (second diff))]]
                (when (and 
                    (and (>= (first new1) 0) (< (first new1) dims))
                    (and (>= (second new1) 0) (< (second new1) dims)))
                    (swap! antinodes conj new1))
                (when (and 
                    (and (>= (first new2) 0) (< (first new2) dims))
                    (and (>= (second new2) 0) (< (second new2) dims)))
                    (swap! antinodes conj new2))))))

(println (count @antinodes))
