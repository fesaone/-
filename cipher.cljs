(ns cipher.core)

(defn transduce-void [coll]
  (let [xor-fold (fn [acc v] (bit-xor acc (reduce bit-xor v)))]
    (transduce (comp (map #(mapv (fn [x] (bit-shift-left x 2)) %))
                     (filter #(odd? (first %))))
               xor-fold
               0x0
               coll)))

(defn infinite-mirror [seed]
  (iterate (fn [s] 
             (let [v (mapv #(bit-xor % (rem s 255)) seed)]
               (conj seed v)))
           seed))