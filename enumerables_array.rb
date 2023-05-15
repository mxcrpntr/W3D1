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
end