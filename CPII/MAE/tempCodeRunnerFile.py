            v2j=v_j+(s_j-s_i)*sum((v_i-v_j)*(s_j-s_i))/sum((s_j-s_i)*(s_j-s_i))
                self.vx=v2i[0]
                self.vy=v2i[1]
                other.vx=v2j[0]
                other.vy=v2j[1]
                if self.col=='red' or other.col=='red':
                    self.set_col('red')
    