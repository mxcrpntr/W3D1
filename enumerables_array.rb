class Array
    def my_each(&prc)
        i = 0
        while i < self.length
            prc.call(self[i])
            i += 1
        end
        self
    end
    def my_select(&prc)
        new_array = []
        prc_2 = Proc.new {|el| new_array << el if prc.call(el)}
        self.my_each(&prc_2)
        new_array
    end

    def my_reject(&prc)
        new_array = []
        prc_2 = Proc.new {|el| new_array << el if !prc.call(el)}
        self.my_each(&prc_2)
        new_array
    end 

    def my_any?(&prc)
        prc_2 = Proc.new {|el| return true if prc.call(el)}
        self.my_each(&prc_2)
        false
    end 

    def my_all?(&prc)
        prc_2 = Proc.new {|el| return false if !prc.call(el)}
        self.my_each(&prc_2)
        true
    end 

    def my_flatten
        flattened = []
        self.each do |el|
            if el.is_a?(Array) 
                flattened += el.my_flatten
            else
                flattened += [el]
            end 
        end 
        flattened
    end     

    def my_zip(*arrs)
        newarr = []
        self.each_with_index do |el, i|
            subarr = []
            subarr << el
            arrs.each do |arr|
                subarr << arr[i]
            end 
            newarr << subarr
        end 
        newarr
    end 

    def my_rotate(n=1)
        newarr = self.dup
        if n >= 0
            n.times do 
                newarr.push(newarr.shift)
            end 
        else 
            (n * -1).times do 
                newarr.unshift(newarr.pop)
            end 
        end 
        newarr
    end 

end

